using Agents
using CairoMakie

@agent struct Ghost(GridAgent{2}) #Definimos la estructura del agente
    type::String = "Ghost"
end

matrix = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 1 0 1 0 0 0 1 1 1 0 1 0 1 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 0 1 0 1 0 0 0 0 0 1 1 1 0 1 0;
    0 1 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 1 0 1 0 1 1 1 0 0 0 1 0 1 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]

function add_ghost!(model, pos)
    add_agent!(Ghost, pos=pos, model)
end


function agent_step!(agent, model)
    possible_moves = []
    x, y = agent.pos

    # Exploramos las direcciones (arriba, abajo, izquierda, derecha)
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    
    for (dx, dy) in directions
        new_x, new_y = x + dx, y + dy
        # Verificamos que la nueva posición esté dentro de los límites y no sea una pared
        if new_x > 0 && new_x ≤ size(matrix, 1) && new_y > 0 && new_y ≤ size(matrix, 2)
            if matrix[new_x, new_y] == 1
                push!(possible_moves, (new_x, new_y))
            end
        end
    end
    
    # Si hay movimientos válidos, seleccionamos uno aleatoriamente
    if !isempty(possible_moves)
        new_pos = rand(possible_moves)
        move_agent!(agent, new_pos, model)
    end
end


function initialize_model()
    space = GridSpace(size(matrix); periodic = false, metric = :manhattan) # Espacio del laberinto
    model = StandardABM(Ghost, space; agent_step!)
    return model
end

model = initialize_model()
a = add_agent!(Ghost, pos=(3, 3), model)
