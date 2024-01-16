* @ValidationCode : MjotMTA0MDU0NDAwMDpDcDEyNTI6MTcwNDc5MjE1NzMzMDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:52:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
   * $INSERT I_BATCH.FILES
   $USING EB.Service
*----------------------------------------------------------------------------

    *IF NOT(CONTROL.LIST) THEN
        ControlListVal = EB.Service.getControlList() ;*R22 UTILITY MANUAL CONVERSION
    IF NOT(ControlListVal) THEN ;*R22 UTILITY MANUAL CONVERSION
        GOSUB REMOVE.FILES
        GOSUB BUILD.CONTROL.LIST
    END
    BEGIN CASE
        *CASE CONTROL.LIST<1,1> EQ 'Y.AP.LOANS'
            CASE ControlListVal<1,1> EQ 'Y.AP.LOANS' ;*R22 UTILITY MANUAL CONVERSION
            GOSUB SEL.AP.LOANS
       * CASE CONTROL.LIST<1,1> EQ 'Y.AP.CARDS'
        CASE ControlListVal<1,1> EQ 'Y.AP.CARDS' ;*R22 UTILITY MANUAL CONVERSION
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
*    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,Y.LIST)
EB.Service.BatchBuildList(LIST.PARAMETERS,Y.LIST);* R22 UTILITY AUTO CONVERSION

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
*    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,Y.LIST)
EB.Service.BatchBuildList(LIST.PARAMETERS,Y.LIST);* R22 UTILITY AUTO CONVERSION
RETURN

BUILD.CONTROL.LIST:
*******************
*    CALL EB.CLEAR.FILE(FN.LAPAP.CONCAT.TMP.CLIENTES, FV.LAPAP.CONCAT.TMP.CLIENTES)
EB.Service.ClearFile(FN.LAPAP.CONCAT.TMP.CLIENTES, FV.LAPAP.CONCAT.TMP.CLIENTES);* R22 UTILITY AUTO CONVERSION
*    CALL EB.CLEAR.FILE(FN.LAPAP.CONCAT.TMP.TIPOGARANTIA, FV.LAPAP.CONCAT.TMP.TIPOGARANTIA)
EB.Service.ClearFile(FN.LAPAP.CONCAT.TMP.TIPOGARANTIA, FV.LAPAP.CONCAT.TMP.TIPOGARANTIA);* R22 UTILITY AUTO CONVERSION
*    CALL EB.CLEAR.FILE(FN.LAPAP.CONCAT.TMP.GESGARANTIAS , FV.LAPAP.CONCAT.TMP.GESGARANTIAS)
EB.Service.ClearFile(FN.LAPAP.CONCAT.TMP.GESGARANTIAS , FV.LAPAP.CONCAT.TMP.GESGARANTIAS);* R22 UTILITY AUTO CONVERSION
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
