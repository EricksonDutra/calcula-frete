import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController placeController = TextEditingController();

  late String latitude;
  late String longitude;

  double custoDoFrete = 0.0;
  double distancia = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calcular frete"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: Image.asset('assets/icon.png', width: 180.0, height: 180.0, fit: BoxFit.cover)),
            const SizedBox(height: 20),
            TextField(
              controller: placeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Latitude e Longitude do Destino'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                elevation: 2,
              ),
              onPressed: () {
                setState(() {
                  // Encontre a posição do primeiro espaço
                  int posicaoEspaco = placeController.text.indexOf(" ");

                  // Use substring para pegar os caracteres até o primeiro espaço
                  latitude = placeController.text.substring(0, posicaoEspaco - 1);
                  longitude = placeController.text.substring(posicaoEspaco + 1);
                });
                calcularFrete();
              },
              child: const Text("Calcular Frete"),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                shadowColor: Colors.pink,
                color: Colors.deepPurple[50],
                margin: const EdgeInsets.all(20),
                elevation: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.carOn,
                      color: Colors.brown,
                      size: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Custo do Frete: R\$ ${custoDoFrete.toStringAsFixed(2)}\nDistância: ${distancia.toStringAsFixed(2)} - km",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.brown),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> calcularFrete() async {
    try {
      double latitudeDestino = double.tryParse(latitude.replaceAll(',', '.')) ?? 0.0;
      double longitudeDestino = double.tryParse(longitude.replaceAll(',', '.')) ?? 0.0;

      print(' lat - $latitudeDestino - long - $longitudeDestino ... ');

      distancia = await calcularDistancia(latitudeDestino, longitudeDestino);

      double preco = calcularPrecoPorQuilometro(
          consumoCombustivel: 8, custosAdicionais: 0.4, margemLucro: 0, precoCombustivel: 6.00);

      print("Preco por km: $preco");
      // Suponha que o custo do frete é R$6.00 por quilômetro
      setState(() {
        custoDoFrete = distancia * preco;
        distancia = distancia;
      });
    } catch (e) {
      setState(() {
        custoDoFrete = 0.0;
        distancia = 0.0;
      });
      print("Erro ao calcular o frete: $e R\$");
    }
    print("Calculei o frete");
    print(custoDoFrete);
  }

  Future<double> calcularDistancia(double latitudeDestino, double longitudeDestino) async {
    double latitudeAtual = -22.525310321147835;
    double longitudeAtual = -55.72490770501493;

    // Use a fórmula Haversine para calcular a distância
    double distancia = Geolocator.distanceBetween(
      latitudeAtual,
      longitudeAtual,
      latitudeDestino,
      longitudeDestino,
    );

    // A distância está em metros, você pode converter para quilômetros
    double distanciaEmKm = (distancia / 1000.0) + 2;
    double distanciaTotal = distanciaEmKm * 2;
    print('Distância:  $distancia');
    print(distanciaEmKm);
    print(distanciaTotal);
    return distanciaTotal;
  }

  double calcularPrecoPorQuilometro({
    required double consumoCombustivel, // em litros por 100 km
    required double precoCombustivel, // preço por litro de combustível
    required double custosAdicionais, // custos adicionais (manutenção, impostos, etc.)
    required double margemLucro, // margem de lucro desejada (ex. 20% = 0,20)
  }) {
    // Calcula o custo do combustível por quilômetro
    double custoCombustivelPorKm = (precoCombustivel / 100) * consumoCombustivel;

    // Calcula o preço por quilômetro
    double precoPorKm = (custoCombustivelPorKm + custosAdicionais) * (1 + margemLucro);

    return precoPorKm;
  }
}

//  Future<void> obterEnderecoDestino() async {
//   String enderecoDestino = 'Carregando...';
//     try {

//       List<Placemark> placemarks = await Geolocator.placemarkFromCoordinates(latitude, longitude);
//       if (placemarks.isNotEmpty) {
//         Placemark destino = placemarks[0];
//         setState(() {
//           enderecoDestino = '${destino.thoroughfare}, ${destino.subThoroughfare}, ${destino.locality}, ${destino.administrativeArea}';
//         });
//       } else {
//         setState(() {
//           enderecoDestino = 'Endereço não encontrado';
//         });
//       }
//     } catch (e) {
//       print('Erro ao obter o endereço: $e');
//       setState(() {
//         enderecoDestino = 'Erro ao obter o endereço';
//       });
//     }
//   }

 