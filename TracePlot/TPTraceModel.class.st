Class {
	#name : #TPTraceModel,
	#superclass : #Object,
	#instVars : [
		'traceModel',
		'data',
		'sortedData'
	],
	#category : #TracePlot
}

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
TPTraceModel >> maxOccurence [
	^ self sortedData first key.

]

{ #category : #'as yet unclassified' }
TPTraceModel >> methodsWithOccurences: anInt [
	^ data at: anInt ifAbsent: [#()].
]

{ #category : #'as yet unclassified' }
TPTraceModel >> sortedData [ 
	^sortedData ifNil: [sortedData := self data associations sort: [:a :b | a key > b key]]. 
	
	

]

{ #category : #'as yet unclassified' }
TPTraceModel >> tagData [

	self maxOccurence <= 10
		ifTrue: [  ]
		ifFalse: [ self tagDataWithMaxOccurenceSupThan10 ]
]

{ #category : #'as yet unclassified' }
TPTraceModel >> tagDataWithMaxOccurenceSupThan10 [
	| power10 |
	power10 := (self maxOccurence log:10) asInteger.
	"tag 1
	tag <= 10
	tag <= 100
	tag <= 1000
	... until 10 power (power10 + 1)"
	(1 to: power10) do: [ :pwr |  ]
	
]

{ #category : #accessing }
TPTraceModel >> traceModel [

	^ traceModel
]

{ #category : #accessing }
TPTraceModel >> traceModel: anObject [

	traceModel := anObject
]
