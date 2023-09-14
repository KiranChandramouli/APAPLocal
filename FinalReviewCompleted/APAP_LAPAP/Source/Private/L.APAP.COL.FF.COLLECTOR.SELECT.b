* @ValidationCode : MjotMzMyNTkzMjQ3OkNwMTI1MjoxNjkxNzUxMzIzNDE0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Aug 2023 16:25:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.COL.FF.COLLECTOR.SELECT
**-----------------------------------------------------------------------------
* REDO COLLECTOR EXTRACT PRE-Process Load routine
* Service : BNK/L.APAP.COL.FF.COLLECTOR
* basada en la logica de la rutina : L.APAP.COL.FF.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* performance creation- collector performance issue creation
*-----------------------------------------------------------------------------
* Date                  Who                               Reference           Description
* ----                  ----                                ----                 ----
* 09-08-2023         Ajith Kumar         R22 Manual Code Conversion        LAPAP.BP,TAM.BP IS REMOVED,VM ,FM to @VM,@FM

* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.COL.FF.EXTRACT.PRE.COMMON ;*R22 MANUAL CODE CONVERSION
    $INSERT I_F.REDO.INTERFACE.PARAM ;*R22 MANUAL CODE CONVERSION
    $INSERT I_L.APAP.COL.COLLECTOR.COMMON ;*R22 MANUAL CODE CONVERSION
    $INSERT I_F.DATES
    $INSERT I_BATCH.FILES
*----------------------------------------------------------------------------

    IF NOT(CONTROL.LIST) THEN
        GOSUB REMOVE.FILES
        GOSUB BUILD.CONTROL.LIST
    END
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ 'Y.AP.LOANS'
            GOSUB SEL.AP.LOANS
        CASE CONTROL.LIST<1,1> EQ 'Y.AP.CARDS'
            GOSUB SEL.AP.CARDS
    END CASE
RETURN

*************
SEL.AP.LOANS:
*************

    LIST.PARAMETERS = '' ; ID.LIST = ''

    GOSUB CRITERIA.VALUE

    Y.SELECT.CMD='SELECT ':FN.AA.ARRANGEMENT :' WITH ':CRITERIA

    CALL EB.READLIST(Y.SELECT.CMD,Y.LIST,'',NO.OF.REC,ERR)
    Y.LIST=SORT(Y.LIST)
    Y.REC.CNT=1
    LOOP
    WHILE Y.REC.CNT LE NO.OF.REC
        IF Y.LIST<Y.REC.CNT> EQ Y.LIST<Y.REC.CNT-1> THEN
            DEL Y.LIST<Y.REC.CNT>
            NO.OF.REC-=1
            Y.REC.CNT--
        END
        Y.REC.CNT++
    REPEAT

    Y.LIST.CNT=DCOUNT(Y.LIST,@FM)
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,Y.LIST)

RETURN
*-------------------------------------------------------------
CRITERIA.VALUE:
*-------------------------------------------------------------
    CHANGE  ',' TO @VM IN NUM.PRODUCT
    CHANGE  ',' TO @VM IN NUM.STATUS
    NUM.PRODUCT =DCOUNT(C.AA.PRODUCT.GROUP<1>,@VM)
    NUM.STATUS  =DCOUNT(C.AA.STATUS<1>,@VM)

    IF NUM.STATUS THEN
        CRITERIA = '('
    END
    FOR I=1 TO NUM.STATUS
        CRITERIA   :='ARR.STATUS EQ '
        CRITERIA   := DQUOTE(C.AA.STATUS<1,I>)
        IF I <> NUM.STATUS THEN
            CRITERIA   :=' OR '
        END
    NEXT I
    IF NUM.STATUS THEN
        CRITERIA := ')'
    END
    CRITERIA   :=' CUSTOMER'
RETURN

*************
SEL.AP.CARDS:
*************
    LIST.PARAMETERS = '' ; Y.LIST = ''
    Y.SELECT.CMD='SELECT ':FN.CUSTOMER
    CALL EB.READLIST(Y.SELECT.CMD,Y.LIST,'',NO.OF.REC,ERR)
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,Y.LIST)
RETURN

BUILD.CONTROL.LIST:
*******************
    CALL EB.CLEAR.FILE(FN.LAPAP.CONCAT.TMP.CLIENTES, FV.LAPAP.CONCAT.TMP.CLIENTES)
    CALL EB.CLEAR.FILE(FN.LAPAP.CONCAT.TMP.TIPOGARANTIA, FV.LAPAP.CONCAT.TMP.TIPOGARANTIA)
    CALL EB.CLEAR.FILE(FN.LAPAP.CONCAT.TMP.GESGARANTIAS , FV.LAPAP.CONCAT.TMP.GESGARANTIAS)
    CONTROL.LIST<-1> = "Y.AP.LOANS"
    CONTROL.LIST<-1> = "Y.AP.CARDS"
RETURN

REMOVE.FILES:
*************
    Y.EXTRACT.OUT.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>
    Y.EXTRACT.HIST.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.HISTORY.PATH>
    SHELL.CMD ='SH -c '
    EXE.MV="mv ":Y.EXTRACT.OUT.PATH:"/*":" ":Y.EXTRACT.HIST.PATH
    DAEMON.CMD = SHELL.CMD:EXE.MV
    EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE
RETURN

END
