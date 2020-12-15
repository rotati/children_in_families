# This is an autogenerated file for dynamic methods in ChangelogType
# Please rerun rake rails_rbi:models to regenerate.
# typed: strong

class ChangelogType::ActiveRecord_Relation < ActiveRecord::Relation
  include ChangelogType::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: ChangelogType)
end

class ChangelogType::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include ChangelogType::ModelRelationShared
  extend T::Generic
  Elem = type_member(fixed: ChangelogType)
end

class ChangelogType < ActiveRecord::Base
  extend T::Sig
  extend T::Generic
  extend ChangelogType::ModelRelationShared
  include ChangelogType::InstanceMethods
  Elem = type_template(fixed: ChangelogType)
end

module ChangelogType::InstanceMethods
  extend T::Sig

  sig { returns(T.nilable(String)) }
  def change_type(); end

  sig { params(value: T.nilable(String)).void }
  def change_type=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def change_type?(*args); end

  sig { returns(T.nilable(Integer)) }
  def changelog_id(); end

  sig { params(value: T.nilable(Integer)).void }
  def changelog_id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def changelog_id?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def created_at(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def created_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def created_at?(*args); end

  sig { returns(T.nilable(String)) }
  def description(); end

  sig { params(value: T.nilable(String)).void }
  def description=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def description?(*args); end

  sig { returns(Integer) }
  def id(); end

  sig { params(value: Integer).void }
  def id=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def id?(*args); end

  sig { returns(T.nilable(T.untyped)) }
  def updated_at(); end

  sig { params(value: T.nilable(T.untyped)).void }
  def updated_at=(value); end

  sig { params(args: T.untyped).returns(T::Boolean) }
  def updated_at?(*args); end

end

class ChangelogType
  extend T::Sig

  sig { returns(T.nilable(::Changelog)) }
  def changelog(); end

  sig { params(value: T.nilable(::Changelog)).void }
  def changelog=(value); end

end

module ChangelogType::ModelRelationShared
  extend T::Sig

  sig { returns(ChangelogType::ActiveRecord_Relation) }
  def all(); end

  sig { params(block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def select(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def order(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def reorder(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def group(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def limit(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def offset(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def joins(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def where(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def rewhere(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def preload(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def eager_load(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def includes(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def from(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def lock(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def readonly(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def or(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def having(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def create_with(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def distinct(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def references(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def none(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def unscope(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ChangelogType::ActiveRecord_Relation) }
  def except(*args, &block); end

end