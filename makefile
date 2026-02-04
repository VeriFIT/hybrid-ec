# both clingcon and clingo
create-env-clingcon:
	conda env create -f ./utils/clingcon_env.yml || \
	conda env update -f ./utils/clingcon_env.yml
# clingo-lpx 14
create-env-lpx:
	conda create -n clingo-lpx -c potassco/label/dev-20 -c conda-forge clingo-lpx

activate-lpx-env:
	@echo "run this manually: conda activate clingo-lpx"
activate-con-env:
	@echo "run this manually: conda activate clingcon"
