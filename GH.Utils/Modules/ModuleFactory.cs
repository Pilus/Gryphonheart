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

    /// <summary>
    /// Factory for modules, which handles loading of settings, as well as allows for singleton management.
    /// </summary>
    public class ModuleFactory : IModuleFactory
    {
        /// <summary>
        /// Singleton module factory.
        /// </summary>
        private static IModuleFactory moduleFactory;

        /// <summary>
        /// List of loaded modules.
        /// </summary>
        private readonly List<IModule> loadedModules = new List<IModule>();

        /// <summary>
        /// List of callback actions registered in the factory.
        /// </summary>
        private readonly List<Action<IModule>> callbackActions = new List<Action<IModule>>();

        /// <summary>
        /// Initializes a new instance of the <see cref="ModuleFactory"/> class.
        /// </summary>
        public ModuleFactory()
        {
        }

        /// <summary>
        /// Gets the singleton instance of the module factory.
        /// </summary>
        public static IModuleFactory ModuleFactorySingleton
        {
            get
            {
                if (moduleFactory == null)
                {
                    moduleFactory = new ModuleFactory();
                }

                return moduleFactory;
            }
            set
            {
                moduleFactory = value;
            }
        }

        /// <summary>
        /// Gets a module from the static module factory.
        /// </summary>
        /// <typeparam name="T">The type of the module.</typeparam>
        /// <returns>The module.</returns>
        public static T GetM<T>() where T : IModule, new()
        {
            return ModuleFactorySingleton.GetModule<T>();
        }

        /// <summary>
        /// Get a module of the desired type.
        /// </summary>
        /// <typeparam name="T">The type of the module.</typeparam>
        /// <returns>The module.</returns>
        public T GetModule<T>() where T : IModule, new()
        {
            var loadedModule = this.loadedModules.OfType<T>().FirstOrDefault();

            if (loadedModule != null && loadedModule.IsSingleton)
            {
                return loadedModule;
            }

            var newModule = new T();

            this.loadedModules.Add(newModule);
            this.callbackActions.ForEach(action => action(newModule));

            return newModule;
        }

        /// <summary>
        /// Registers a callback that is triggered when a module is being created.
        /// </summary>
        /// <param name="callback">The callback triggered.</param>
        public void RegisterForModuleLoadEvents(Action<IModule> callback)
        {
            this.callbackActions.Add(callback);
        }

        /// <summary>
        /// Gets an array of all modules that have already been loaded.
        /// </summary>
        /// <returns>The loaded modules.</returns>
        public IModule[] GetAllLoadedModules()
        {
            return this.loadedModules.ToArray();
        }
    }
}