#The Output Section 

output "lustre_id" {
  description = "The ID of the newly created managed luster file system."
  value       = module.luster01.lstr_id
}