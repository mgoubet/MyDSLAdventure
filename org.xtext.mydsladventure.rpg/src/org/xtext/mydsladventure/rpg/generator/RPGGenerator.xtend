/*
 * generated by Xtext 2.15.0
 */
package org.xtext.mydsladventure.rpg.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class RPGGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		(new ASLXGenerator()).doGenerate(resource, fsa, context);
		(new CardGenerator()).doGenerate(resource, fsa, context);
		(new MapGenerator()).doGenerate(resource, fsa, context);
		(new ZipGenerator()).doGenerate(resource, fsa, context);
	}
	
}
