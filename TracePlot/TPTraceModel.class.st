Class {
	#name : #TPTraceModel,
	#superclass : #Object,
	#instVars : [
		'traceModel',
		'data',
		'sortedData',
		'codeModel'
	],
	#category : #TracePlot
}

{ #category : #accessing }
TPTraceModel >> codeModel [

	^ codeModel
]

{ #category : #accessing }
TPTraceModel >> codeModel: anObject [

	codeModel := anObject
]

{ #category : #'as yet unclassified' }
TPTraceModel >> computeData [

	| array dict |
	array := traceModel methodSignatures asBag sortedCounts.
	dict := Dictionary new.
	array do: [ :assoc |
		dict
			at: assoc key
			ifPresent: [ :c | c add: assoc value ]
			ifAbsentPut: [
				OrderedCollection new
					add: assoc value;
					yourself ] ].
	self data: dict
]

{ #category : #'as yet unclassified' }
TPTraceModel >> computeTraceModelFrom: aFileName [

	^ self traceModel: (self createTraceModelFrom: aFileName)
]

{ #category : #'as yet unclassified' }
TPTraceModel >> createTags [
	| power10 |
	power10 := (self maxExecution log:10) asInteger.
	"tag 1
	tag <= 10
	tag <= 100
	tag <= 1000
	... until 10 power (power10 + 1)"
	traceModel createTagNamed: 'nbOfExecutions = 1'.
	1 to: power10 do: [ :pwr | 
		traceModel createTagNamed: 'nbOfExecutions <= ', (pwr*10) asString.
	 ]
	
]

{ #category : #'as yet unclassified' }
TPTraceModel >> createTraceModelFrom: aFileName [

	^ OTelJavaLogFileLoader new load: (self extractTraceFrom: aFileName)
]

{ #category : #accessing }
TPTraceModel >> data [

	^ data
]

{ #category : #accessing }
TPTraceModel >> data: anObject [

	data := anObject
]

{ #category : #'as yet unclassified' }
TPTraceModel >> extractTraceFrom: aFileName [
 ^ (OTelJavaLogFileExtractor new filename: aFileName) extract
]

{ #category : #'as yet unclassified' }
TPTraceModel >> initializeModel [
	codeModel := FamixJavaModel new.
	self data values flatten do: [ :m | FamixJavaMethod new name: m ; mooseModel: codeModel ].
]

{ #category : #'as yet unclassified' }
TPTraceModel >> maxExecution [
	^ self sortedData first key.

]

{ #category : #'as yet unclassified' }
TPTraceModel >> methodsWithNbExecutions: anInt [
	^ data at: anInt ifAbsent: [#()].
]

{ #category : #'as yet unclassified' }
TPTraceModel >> sortedData [ 
	^sortedData ifNil: [sortedData := self data associations sort: [:a :b | a key > b key]]. 
	
	

]

{ #category : #'as yet unclassified' }
TPTraceModel >> tagData [

	self maxExecution <= 10
		ifFalse: [ self tagDataWithMaxNbExecutionsSupThan10  ]
]

{ #category : #'as yet unclassified' }
TPTraceModel >> tagDataWithMaxNbExecutionsSupThan10 [

	self sortedData do: [ :assoc |
		| pwr tagName |
		pwr := (assoc key log: 10) asInteger.
		tagName := 'nbOfExecutions <= ', (pwr*10) asString.
		assoc value do: [ :mn |
			| famixMethod |
			famixMethod := self codeModel allModelMethods detect: [ :m |
				               m name = mn ].
			famixMethod tagWithName: tagName tagModel:  self codeModel
			
			] ]
]

{ #category : #accessing }
TPTraceModel >> traceModel [

	^ traceModel
]

{ #category : #accessing }
TPTraceModel >> traceModel: anObject [

	traceModel := anObject
]
