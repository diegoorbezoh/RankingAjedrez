=begin

Algoritmo ELO para ranking de ajedrez

El modo de asignar este ranking se basa en el algoritmo desarrollado por Elo para rankear a los jugadores de ajedrez considerando su nivel, esto es muy importante, pues no se puede comparar 
a quien tiene un nivel muy alto contra alguien que posee un bajo puntaje. en ese sentido, si así fuese, la fórmula pondera en función de la diferencia, asignando menos puntaje al que tenía 
más si es que gana, o un mayor puntaje al que derrotó a uno de alto nivel.

Criterios:
1- El participanteA siempre será el menor.
2- Puntajes gana: 1.0pto, empata: 0.5ptos, pierde: 0.0ptos

=end

class Ajedrez
	attr_accessor :nombre,:puntaje
	def initialize(nombre,puntaje)
		@nombre,@puntaje = nombre,puntaje
	end
end

class ParticipanteA < Ajedrez
	def initialize(nombre,puntaje)
		super(nombre,puntaje)
	end
end

class ParticipanteB < Ajedrez
	def initialize(nombre,puntaje)
		super(nombre,puntaje)
	end
end

class Administrador
	attr_accessor :arreglo_participantes
	def initialize()
		@arreglo_participantes = []
	end

	def registrar_participantes(nuevoParticipante)
		arreglo_participantes.push(nuevoParticipante)
	end

	def mostrar_participantes
		puts "========================================================="		
		puts "Score Inicial"
		puts "========================================================="
		for p in arreglo_participantes
			puts "#{p.nombre} | #{p.puntaje}"
		end

		puts ""
	end

	def calculoRanking(resultadoA,resultadoB)

		puts "========================================================="		
		puts "Enfrentamientos"
		puts "========================================================="

		ganador = 1.0
		empate = 0.5
		perdedor = 0.0
		constante = 30.00

		mayorPuntaje = nil
		mayor = 0.0
		menorPuntaje = nil
		menor = 9999

		for i in arreglo_participantes
			if i.puntaje > mayor
				mayor = i.puntaje
			end
			if i.puntaje < menor
				menor = i.puntaje
			end
		end

		#Algoritmo para rankear
		#Calculamos el puntaje previo según los niveles

		ea = 1 / (1 + (10 ** ( (mayor-menor)/400) ))
		eb = 1 / (1 + (10 ** ( (menor-mayor)/400) ))

		#Calculamos el puntaje final
		# Rn = Ro + C * (S - Se)

		case resultadoA
			when "G"
			rna = menor + constante * (ganador - ea)
			puts "El participante 01 es el ganador, logrando: " + ((rna - menor).round(2)).to_s + " puntos"		
			when "E"
			rna = menor + constante * (empate - ea)
			puts "El participante 01 logró un empate, obteniendo " + ((rna - menor).round(2)).to_s + " puntos"
			when "P"
			rna = menor + constante * (perdedor - ea)
			puts "El participante 01 perdió, reduciendo sus puntos a " + ((rna - menor).round(2)).to_s
		end

		case resultadoB
			when "G"
			rnb = mayor + constante * (ganador - eb)
			puts "El participante 02 es el ganador, logrando: " + ((rnb - mayor).round(2)).to_s + " puntos"
			puts "======================================================"
			puts "Nueva puntuación"
			puts "======================================================"

			when "E"
			rnb = mayor + constante * (empate - eb)
			puts "El participante 02 logró un empate, obteniendo: " + ((rnb - mayor).round(2)).to_s + " puntos"
			puts "======================================================"
			puts "Nueva puntuación"
			puts "======================================================"
			when "P"
			rnb = mayor + constante * (perdedor - eb)
			puts "El participante 02 perdió, reduciendo sus puntos a: " + ((rnb - mayor).round(2)).to_s
			puts "======================================================"
			puts "Nueva puntuación"
			puts "======================================================"

		end
		puts rna.round(2)
		puts rnb.round(2)
		puts "=="
	end
end

class Factoria
		def self.obtenerObjeto(tipo,*arg)
			case tipo
				when "Jugador01"
				ParticipanteA.new(arg[0],arg[1])
				when "Jugador02"
				ParticipanteB.new(arg[0],arg[1])
			else nil
		end
	end	
end


participante01 = Factoria.obtenerObjeto("Jugador01","Juan",100.00)
participante02 = Factoria.obtenerObjeto("Jugador02","Luis",910.00)

enfrentamientos = Administrador.new()

enfrentamientos.registrar_participantes(participante01)
enfrentamientos.registrar_participantes(participante02)

enfrentamientos.mostrar_participantes
#Enfrentamiento donde gana el participante 01, quien tiene un score de 100.
#observamos que obtiene 29 puntos y el participante 02, quien cuenta con un score de 800, pierde 29.
enfrentamientos.calculoRanking("G","P")

#Enfrentamiento donde ambos obtienen un empate
#El primero obtiene 14pts y el 2do pierde 14pts
#enfrentamientos.calculoRanking("E","E")

#Enfrentamiento donde el participante 02 gana
#Obtiene solo 01 punto y el primer participante pierde 1punto.
#enfrentamientos.calculoRanking("P","G")

#De esta forma los puntos obtenidos son de forma equitativa según el nivel



