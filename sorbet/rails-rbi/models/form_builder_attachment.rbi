# This is an autogenerated file for dynamic methods in FormBuilderAttachment
# Please rerun rake rails_rbi:models to regenerate.
# typed: strong

class FormBuilderAttachment::ActiveRecord_Relation < ActiveRecord::Relation
  include FormBuilderAttachment::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: FormBuilderAttachment)
end

class FormBuilderAttachment::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include FormBuilderAttachment::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: FormBuilderAttachment)
end

class FormBuilderAttachment < ActiveRecord::Base
  extend T::Sig
  extend T::Generic
  extend FormBuilderAttachment::ModelRelationShared
  include FormBuilderAttachment::InstanceMethods
  Elem = type_template(fixed: FormBuilderAttachment)
end

module FormBuilderAttachment::InstanceMethods
  extend T::Sig

  sig { returns(T.untyped) }
  def created_at(); end

  sig { params(value: T.untyped).void }
  def created_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def created_at?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def file(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def file=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def file?(*args); end

  sig { returns(T.nilable(Integer)) }
  def form_buildable_id(); end

  sig { params(value: T.nilable(Integer)).void }
  def form_buildable_id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def form_buildable_id?(*args); end

  sig { returns(T.nilable(String)) }
  def form_buildable_type(); end

  sig { params(value: T.nilable(String)).void }
  def form_buildable_type=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def form_buildable_type?(*args); end

  sig { returns(Integer) }
  def id(); end

  sig { params(value: Integer).void }
  def id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def id?(*args); end

  sig { returns(T.nilable(String)) }
  def name(); end

  sig { params(value: T.nilable(String)).void }
  def name=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def name?(*args); end

  sig { returns(T.untyped) }
  def updated_at(); end

  sig { params(value: T.untyped).void }
  def updated_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def updated_at?(*args); end

end

class FormBuilderAttachment
  extend T::Sig

  sig { returns(T.nilable(T.untyped)) }
  def form_buildable(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def form_buildable=(value); end

end

module FormBuilderAttachment::ModelRelationShared
  extend T::Sig

  sig { returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def all(); end

  sig { params(block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def find_by_form_buildable(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def select(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def order(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def reorder(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def group(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def limit(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def offset(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def joins(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def where(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def rewhere(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def preload(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def eager_load(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def includes(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def from(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def lock(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def readonly(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def or(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def having(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def create_with(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def distinct(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def references(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def none(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def unscope(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(FormBuilderAttachment::ActiveRecord_Relation) }
  def except(*args, &block); end

end