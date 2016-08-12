//-----------------------–-----------------------–--------------
// <copyright file="ModuleFactory.cs">
//  Copyright (c) 2016 Gryphonheart Team. All rights reserved.
// </copyright>
//-----------------------–-----------------------–--------------

namespace GH.Utils.Modules
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using GH.Utils.Entities;

    /// <summary>
    /// Factory for modules, which handles loading of settings, as well as allows for singleton management.
    /// </summary>
    public class ModuleFactory : IModuleFactory
    {
        private readonly List<ModuleTypeInfo> loadedModuleInfo = new List<ModuleTypeInfo>();
        private readonly Dictionary<string, IIdObject<string>> appliedSettings = new Dictionary<string, IIdObject<string>>();
        private readonly List<Action<IModule>> callbackActions = new List<Action<IModule>>();

        /// <summary>
        /// Get a module of the desired type.
        /// </summary>
        /// <typeparam name="T">The type of the module.</typeparam>
        /// <returns>The module.</returns>
        public T GetModule<T>() where T : IModule, new()
        {
            var moduleInfo = this.GetModuleInfo<T>();

            if (moduleInfo != null && moduleInfo.IsSingleton)
            {
                return (T)moduleInfo.LoadedModules.First();
            }

            var newModule = new T();

            if (moduleInfo != null)
            {
                moduleInfo.LoadedModules.Add(newModule);

                if (this.appliedSettings.ContainsKey(moduleInfo.SettingsId))
                {
                    newModule.ApplySettings(this.appliedSettings[moduleInfo.SettingsId]);
                }
            }
            else
            {
                var defaultSettings = newModule.GetDefaultSettings();
                this.loadedModuleInfo.Add(new ModuleTypeInfo()
                {
                    ModuleType = typeof(T),
                    DefaultSettings = defaultSettings,
                    LoadedModules = new IModule[] { newModule }.ToList(),
                    SettingsId = defaultSettings.Id,
                    IsSingleton = newModule.IsSingleton
                });

                if (this.appliedSettings.ContainsKey(defaultSettings.Id))
                {
                    newModule.ApplySettings(this.appliedSettings[defaultSettings.Id]);
                }
            }

            this.callbackActions.ForEach(action => action(newModule));

            return newModule;
        }

        /// <summary>
        /// Loads a given set of settings to apply to all existing modules and all future modules.
        /// </summary>
        /// <param name="settings">The settings to apply.</param>
        public void LoadSettings(IEnumerable<IIdObject<string>> settings)
        {
            foreach (var moduleSettings in settings)
            {
                this.appliedSettings[moduleSettings.Id] = moduleSettings;

                var moduleInfo = this.GetModuleInfo(moduleSettings.Id);

                if (moduleInfo != null)
                {
                    foreach (var module in moduleInfo.LoadedModules)
                    {
                        module.ApplySettings(moduleSettings);
                    }
                }
            }
        }

        /// <summary>
        /// Gets the default settings of all already loaded modules.
        /// </summary>
        /// <returns>The settings to load.</returns>
        public IEnumerable<IIdObject<string>> GetDefaultSettingsOfLoadedModules()
        {
            return this.loadedModuleInfo.Select(mi => mi.DefaultSettings);
        }

        /// <summary>
        /// Registers a callback that is triggered when a module is being created.
        /// </summary>
        /// <param name="callback">The callback triggered.</param>
        public void RegisterForModuleLoadEvents(Action<IModule> callback)
        {
            this.callbackActions.Add(callback);
        }

        private ModuleTypeInfo GetModuleInfo<T>()
        {
            return this.loadedModuleInfo.SingleOrDefault(lm => lm.ModuleType == typeof(T));
        }

        private ModuleTypeInfo GetModuleInfo(string settingsId)
        {
            return this.loadedModuleInfo.SingleOrDefault(lm => lm.SettingsId == settingsId);
        }
    }
}