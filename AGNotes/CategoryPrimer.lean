import Mathlib

namespace CategoryPrimer

open CategoryTheory



-- 1.1.A A group is equivalent to a groupoid with just one element.
def groupEquivSingletonGroupoid (A : Type*) :
    Group A ≃ Groupoid (SingleObj A) := {
      toFun := fun (g: Group A) => sorry,
      invFun := fun (c: Groupoid (SingleObj A)) => sorry,
      left_inv := fun (g: Group A) => sorry,
      right_inv := fun (c: Groupoid (SingleObj A)) => sorry
    }

variable {C : Type*} [Category C] (A B : C)

-- Every Aut A is also a groupoid with just one element.
@[reducible] def autIsSingletonGroupoid : Groupoid (SingleObj (Aut A)) where
  id _ := Iso.refl A
  comp f g := g ≪≫ f
  inv f := Iso.symm f
  id_comp f := by -- ∀f ∈ Aut A, id ∘ f = f
    change f ≪≫ (Iso.refl A) = f -- f <> id = f by comp def
    ext -- (f <> id).hom = f.hom ≫ id.hom = f.hom by extension de-parenthesis
    exact Category.comp_id f.hom -- the prev is exactly Category.comp_id

  comp_id f := by -- ∀f ∈ Aut A, f ∘ id = f
    change (Iso.refl A) ≪≫ f = f -- id <> f = f by comp def
    ext -- (id <> f).hom = id.hom ≫ f.hom = f.hom by extension de-parenthesis
    exact Category.id_comp f.hom -- the prev is exactly Category.id_comp
  assoc f g h := by -- ∀ f,g,h ∈ Aut A, (f ∘ g) ∘ h = f ∘ (g ∘ h)
    change h ≪≫ (g ≪≫ f) = (h ≪≫ g) ≪≫ f -- h <> (g <> f) = (h <> g) <> f by comp def
    ext -- h.hom ≫ (g.hom ≫ f.hom) = (h.hom ≫ g.hom) ≫ f.hom by ext de-parenthesis
    exact (Category.assoc h.hom g.hom f.hom).symm -- the prev can be applied to Category.assoc
  inv_comp f := by
    change f ≪≫ f.symm = Iso.refl A
    ext
    exact f.hom_inv_id
  comp_inv f := by
    change f.symm ≪≫ f = Iso.refl A
    ext
    exact f.inv_hom_id

-- 1.1.B (1) Aut A is a group.
-- Proven using autIsSingletonGroupoid and groupEquivSingletonGroupoid
@[reducible] def autIsGroupViaGroupoid : Group (Aut A) :=
  (groupEquivSingletonGroupoid (Aut A)).invFun (autIsSingletonGroupoid A)

-- 1.1.B (2) Object isomorphism implies Aut group isomorphism
def autIsomorphicOfIso (F : A ≅ B) : Aut A ≃* Aut B where
  toFun f := F.symm ≪≫ f ≪≫ F
  invFun g := F ≪≫ g ≪≫ F.symm
  left_inv f := by ext; simp
  right_inv g := by ext; simp
  map_mul' f₁ f₂ := by sorry
end CategoryPrimer
