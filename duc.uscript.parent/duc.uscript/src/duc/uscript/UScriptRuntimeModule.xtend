/*
 * generated by Xtext 2.16.0
 */
package duc.uscript

import com.google.inject.Binder
import org.eclipse.xtext.scoping.IScopeProvider
import com.google.inject.name.Names
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import duc.uscript.scoping.UScriptImportedNamespaceAwareLocalScopeProvider

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class UScriptRuntimeModule extends AbstractUScriptRuntimeModule {
	
	override void configureIScopeProviderDelegate(Binder binder) {
		binder.bind(IScopeProvider)
			.annotatedWith(Names.named(AbstractDeclarativeScopeProvider.NAMED_DELEGATE))
			.to(UScriptImportedNamespaceAwareLocalScopeProvider)
	}
}
