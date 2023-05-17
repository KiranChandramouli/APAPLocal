*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.ACQUIRER.TXN
************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VISA.ACQUIRER.TXN
***********************************************************************************
*Description: This is a single threaded job will be attached before A100 stage
*             This will pick the FT ids and ATM.REVERSAL in order to generate
*             outgoing file in the COB
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*07.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_BATCH.FILES

  GOSUB INIT
  GOSUB PROCESS

  RETURN

****
INIT:
*****

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.REDO.VISA.FT.LOG = 'F.REDO.VISA.FT.LOG'
  F.REDO.VISA.FT.LOG = ''
  CALL OPF(FN.REDO.VISA.FT.LOG,F.REDO.VISA.FT.LOG)

  RETURN

*******
PROCESS:
*******
*Get the FTTC ids from BATCH.DETAILS<3,1>


  CLR.CMD='CLEAR.FILE ':FN.REDO.VISA.FT.LOG
  EXECUTE CLR.CMD

  FTTC.ID = BATCH.DETAILS<3,1>
  CHANGE SM TO FM IN FTTC.ID
  LOOP
    REMOVE  Y.FTTC.ID FROM FTTC.ID SETTING ID.POS
  WHILE Y.FTTC.ID:ID.POS
    ID.TEXT='"@ID:' ; MSG.DELIM="'*':" ; UNIQ.ID='AT.UNIQUE.ID"'
    EVA.TEXT=ID.TEXT:MSG.DELIM:UNIQ.ID
    SEL.LIST = '' ; SEL.CMD ='' ; REC.ERR = ''
    SEL.CMD ="SELECT ":FN.FUNDS.TRANSFER:" WITH TRANSACTION.TYPE EQ ":Y.FTTC.ID:" AND DEBIT.VALUE.DATE EQ ":TODAY:" SAVING EVAL ":EVA.TEXT
*write the records
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
    CALL F.WRITE(FN.REDO.VISA.FT.LOG,Y.FTTC.ID,SEL.LIST)
  REPEAT
  RETURN
****************************************************
END
*-----------------End of program-----------------------
