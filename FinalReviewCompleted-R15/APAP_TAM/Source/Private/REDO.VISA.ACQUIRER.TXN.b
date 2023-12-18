* @ValidationCode : MjotMTAxMTI4OTQzNTpDcDEyNTI6MTcwMjY1ODIzODA4NDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIzX1NQNC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 Dec 2023 22:07:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R23_SP4.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2023. All rights reserved.
$PACKAGE APAP.TAM
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
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM SM TO @SM
*19-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*15-05-2023              Edwin D                  R22 Code conversion                         COB issues
*---------------------------------------------------------------------------------------------------------------------------
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

    LOC.REF.APPLICATION = "FUNDS.TRANSFER"   ; * R22 code conversion
    LOC.REF.FIELDS = "AT.UNIQUE.ID"
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.AT.UNIQUE.ID = LOC.REF.POS<1,1>

RETURN

*******
PROCESS:
*******
*Get the FTTC ids from BATCH.DETAILS<3,1>


    CLR.CMD='CLEAR.FILE ':FN.REDO.VISA.FT.LOG
    EXECUTE CLR.CMD

    FTTC.ID = BATCH.DETAILS<3,1>
    CHANGE @SM TO @FM IN FTTC.ID
    LOOP
        REMOVE  Y.FTTC.ID FROM FTTC.ID SETTING ID.POS
    WHILE Y.FTTC.ID:ID.POS
        ID.TEXT='"@ID:' ; MSG.DELIM="'*':" ; UNIQ.ID='AT.UNIQUE.ID"'
        EVA.TEXT=ID.TEXT:MSG.DELIM:UNIQ.ID
        SEL.LIST = '' ; SEL.CMD ='' ; REC.ERR = ''
*        SEL.CMD ="SELECT ":FN.FUNDS.TRANSFER:" WITH TRANSACTION.TYPE EQ ":Y.FTTC.ID:" AND DEBIT.VALUE.DATE EQ ":TODAY:" SAVING EVAL ":EVA.TEXT ; * R22 code conversion
        SEL.CMD ="SELECT ":FN.FUNDS.TRANSFER:" WITH TRANSACTION.TYPE EQ ":DQUOTE(Y.FTTC.ID):" AND DEBIT.VALUE.DATE EQ ":DQUOTE(TODAY)
*write the records
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
        SEL.NEW.LIST = ''
        LOOP
            REMOVE FT.ID FROM SEL.LIST SETTING FT.POS
        WHILE FT.ID:FT.POS
            FT.ERR = '' ; R.FT = ''
            CALL F.READ(FN.FUNDS.TRANSFER, FT.ID, R.FT, F.FUNDS.TRANSFER, FT.ERR)
            IF NOT(FT.ERR) THEN
                IF NOT(SEL.NEW.LIST) THEN
                    SEL.NEW.LIST = FT.ID:'*':R.FT<FT.LOCAL.REF, POS.AT.UNIQUE.ID>
                END ELSE
                    SEL.NEW.LIST<-1> = FT.ID:'*':R.FT<FT.LOCAL.REF, POS.AT.UNIQUE.ID>
                END
            END
        REPEAT
        CALL F.WRITE(FN.REDO.VISA.FT.LOG,Y.FTTC.ID,SEL.NEW.LIST)
    REPEAT
RETURN
****************************************************
END
*-----------------End of program-----------------------
