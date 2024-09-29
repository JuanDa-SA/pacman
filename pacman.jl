
#
using Agents
using CairoMakie

@agent struct Ghost(GridAgent{2}) #Definimos la estructura del agente
    type::String = "Ghost"
end

function agent_step!(agent, model)
    randomwalk!(agent, model)
end

function initialize_model()
    space = GridSpace((5,5); periodic = false, metric = :manhattan) #lugar donde se va a ejecutar
    model = StandardABM(Ghost, space; agent_step!)
    return model
end

model = initialize_model()
a = add_agent!(Ghost, pos=(3, 3), model)