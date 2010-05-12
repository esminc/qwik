= Diff
(({diff.rb})) - computes the differences between two arrays or
strings. Copyright (C) 2001-2002 Lars Christensen.

== Synopsis

    diff = Diff.diff(a, b)
    a.diff(b)
    b = a.patch(diff)

== Module Diff
=== Module Methods
--- Diff.diff(a, b, &block)

      Creates a different set which represents the differences between
      ((|a|)) and ((|b|)). ((|a|)) and ((|b|)) can be either be arrays
      with elements of any type, strings, or object of any class that
      include module ((|Diffable|))

      If a block is not given, the default is to compact the
      difference set elements into an array of element of the type
      (({[action,position,elements]})). If action is :+, the array
      represent elements which is in b but not a which are inserted at
      ((|position|)). If action is :-, the array represents elements
      which are in a at ((|position|)) but has been removed from b. If
      the original data was arrays, ((|elements|)) will be an array of
      elements. If the original data was Strings, then ((|elements|))
      will be a string.c

      If a block is given, it will be passed each of the element in
      the difference set. Each time it is called, three arguments are
      passed: action, position and element. Action is either :+ or :-
      for add or remove element, respectively. If the action is :+,
      position will denote the position to add element in the
      destination set, given all previous before this are changed. If
      the action is :-, position will denote the position to delete
      elements from the original set.


== Module Diffable

The ((|Diffable|)) module can be included into classes that you want
to compute difference sets for Diffable is included into String and
Array when (({diff.rb})) is (({require}))'d.

Classes including Diffable should implement (({[]})) to get element at
integer indices, (({<<})) and (({push})) to append elements to the
object and (({ClassName#new})) should accept 0 arguments to create a
new empty object. Finally, the class must implement the length method
which should return the number of element in the array.

=== Instance Methods
--- Diffable#diff(b, &block)
      Convinience method which calls Diff.diff(self, b, &block).

--- Diffable#patch(diff)
      Applies the differences from ((|diff|)) to the object ((|obj|))
      and return the result. ((|obj|)) is not changed. ((|obj|)) and
      can be either an array or a string, but must match the object
      from which the ((|diff|)) was created.
