* @ValidationCode : MjotMTIyNzc3Nzg3NDpDcDEyNTI6MTY4NDg0MjE1MDQyMzpJVFNTOi0xOi0xOjM4MjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 382
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
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
        SEL.CMD ="SELECT ":FN.FUNDS.TRANSFER:" WITH TRANSACTION.TYPE EQ ":Y.FTTC.ID:" AND DEBIT.VALUE.DATE EQ ":TODAY:" SAVING EVAL ":EVA.TEXT
*write the records
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
        CALL F.WRITE(FN.REDO.VISA.FT.LOG,Y.FTTC.ID,SEL.LIST)
    REPEAT
RETURN
****************************************************
END
*-----------------End of program-----------------------
