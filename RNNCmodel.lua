  require 'Model/RNNC'
  require 'rnn'
  if cuda
  then
    print("CUNN")
    require 'cutorch'
    require 'cunn'
    if cutorch.getDeviceCount() > params.GPU or params.GPU < 1 then
      params.GPU = 1
    end
    cutorch.setDevice(params.GPU)
  end


  model = RNNC() 

  inmodel = nn.Sequential()
  inmodel:add(nn.GRU(1281,500))
  --inmodel:add(nn.Dropout())
  if not params.temporalconv then 
    model:addlayer(nn.Sequencer(inmodel))
  else
    model:addlayer(nn.Sequencer(nn.GRU(32,80)))
    model:addlayer(nn.Sequencer(nn.TemporalConvolution(80,36,params.windowsize,params.stepsize ) ))
  end
  --model:addlayer(nn.Sequencer(nn.GRU(1000,80)))
  model:addlayer(nn.Sequencer(nn.Sequential():add(nn.Linear(500,128)):add(nn.Sigmoid()) ))
  --model:addlayer(nn.Sequencer(nn.Sigmoid()))
   if(cuda) then
  	model:cudaify('torch.FloatTensor')       
   end
    model:printmodel()



  criterion = nn.BCECriterion(nil,false)

  optimState = {
  --eps=1e-3,
    --learningRate = 0.005,
    --weightDecay = 0.01,
    --momentum = .01,
    --learningRateDecay = 1e-7
  }