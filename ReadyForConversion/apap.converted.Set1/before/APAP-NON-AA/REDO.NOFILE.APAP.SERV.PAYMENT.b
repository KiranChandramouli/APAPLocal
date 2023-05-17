*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.APAP.SERV.PAYMENT(LIST.PAY)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.V.ACH.POP.DETAILS
*-----------------------------------------------------------------------------
* Description :
* Linked with :
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*12/11/11      PACS001464107           PRABHU N                   MODIFICATION
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.BENEFICIARY
$INSERT I_System
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.AI.REDO.ARCIB.PARAMETER


  GOSUB OPEN.FILES
  GOSUB FILL.DETAILS.FT
  RETURN
*-----------*
OPEN.FILES:
*-----------*


  GET.ARC.CHG.CODE = ''
  APAP.ARC.SERVICE = ''
  APAP.ARC.AMT = ''
  Y.CHARGE.KEY = ''
  FN.ARCIB.PARAM='F.AI.REDO.ARCIB.PARAMETER'
  F.ARCIB.PARAM=''
  CALL OPF(FN.ARCIB.PARAM,F.ARCIB.PARAM)

  FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE=''
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
  GET.ARC.CHG.CODE = System.getVariable("CURRENT.ARC.CHG.CODE")

  RETURN

*------------*
FILL.DETAILS.FT:
*------------*
  CALL CACHE.READ(FN.ARCIB.PARAM,'SYSTEM',R.ARC.REC,ARC.ERR)
  IF R.ARC.REC THEN
    APAP.ARC.SERVICE = R.ARC.REC<AI.PARAM.ARC.SERVICE>
    APAP.ARC.CHG.CODE = R.ARC.REC<AI.PARAM.ARC.CHARGE.CODE>

    TOT.APAP.SER = DCOUNT(APAP.ARC.SERVICE,VM)
    CNT.SERVICE = 1
    LOOP

      REMOVE APAP.SERVICE FROM APAP.ARC.SERVICE SETTING APAP.SERV.POS
    WHILE CNT.SERVICE LE TOT.APAP.SER
      SERVICE.ID =R.ARC.REC<AI.PARAM.ARC.SERVICE,CNT.SERVICE>
      SERVICE.CODE = R.ARC.REC<AI.PARAM.ARC.CHARGE.CODE,CNT.SERVICE>
      CALL F.READ(FN.FT.COMMISSION.TYPE,SERVICE.CODE,R.COMM.CODE,F.FT.COMMISSION.TYPE,COMM.ERR)
      IF R.COMM.CODE AND SERVICE.ID THEN

        SERVICE.AMT = R.COMM.CODE<FT4.FLAT.AMT>
        LIST.PAY<-1> = SERVICE.ID:"@":SERVICE.AMT:"@":SERVICE.CODE

      END
      CNT.SERVICE++
    REPEAT

  END



  RETURN

END
