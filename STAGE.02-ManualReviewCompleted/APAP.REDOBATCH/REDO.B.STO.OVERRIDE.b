* @ValidationCode : MjoxNzY5MzQ0NTg5OkNwMTI1MjoxNjgxMzYzMTgzOTA5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 10:49:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.STO.OVERRIDE(FT.ID)
*--------------------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is the record routine of the batch job REDO.B.STO.OVERRIDE
* This routine process the FT records in IHLD condition when credit account is arrangement account and
* also checks the exclusion of override messages specified in the param table REDO.STO.OVERRIDE.PARAM
* -------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : FT.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date           who           Reference                          Description
* 24-AUG-2011   Sudharsanan   TAM-ODR-2009-10-0331(PACS0054326)   Initial Creation
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND ++ TO += 1 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.B.STO.OVERRIDE.COMMON

    GOSUB ACCOUNT.CHECK
    IF VAR.ARR.ID AND Y.MSG THEN
        GOSUB PROCESS
    END
RETURN
*----------------
ACCOUNT.CHECK:
*----------------
    FLAG = ''  ; VAR.ARR.ID = ''
    CALL F.READ(FN.FUNDS.TRANSFER,FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANS.ERR)
    IF R.FUNDS.TRANSFER THEN
        VAR.CRD.ACC = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
        CALL F.READ(FN.ACCOUNT,VAR.CRD.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        VAR.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    END
RETURN
*---------
PROCESS:
*---------
    Y.OVERRIDE  = R.FUNDS.TRANSFER<FT.OVERRIDE>
    IF Y.OVERRIDE THEN
        CHANGE @VM TO @FM IN Y.OVERRIDE
        MSG.FM.CNT = DCOUNT(Y.MSG,@FM) ; MSG.CNT = 1
        LOOP
        WHILE MSG.CNT LE MSG.FM.CNT
            MSG.VALUE = Y.MSG<MSG.CNT>
            GOSUB CHECK.DELIMITER
            MSG.CNT += 1
        REPEAT
    END
    IF NOT(FLAG) THEN
        GOSUB OFS.CHECK.PROCESS
    END
RETURN
*-----------------
CHECK.DELIMITER:
*-----------------
    CNT.MSG.VALUE = DCOUNT(MSG.VALUE,'&')
    BEGIN CASE
        CASE CNT.MSG.VALUE EQ 1
            FINDSTR MSG.VALUE IN Y.OVERRIDE SETTING POS THEN
                FLAG = 1
                MSG.CNT = MSG.FM.CNT+1
            END
        CASE CNT.MSG.VALUE GT 1
            GOSUB CHECK.VALUE
    END CASE
RETURN
*------------
CHECK.VALUE:
*------------
    CNT.VALUE = 1
    VAR.MSG.VALUE  =  FIELD(MSG.VALUE,'&',CNT.VALUE)
    FINDSTR VAR.MSG.VALUE IN Y.OVERRIDE SETTING POS1 THEN
        VAR.OVERRIDE.MSG = Y.OVERRIDE<POS1>
        LOOP
        WHILE CNT.VALUE LE CNT.MSG.VALUE
            VAR.MSG.VALUE  =  FIELD(MSG.VALUE,'&',CNT.VALUE)
            FINDSTR VAR.MSG.VALUE IN VAR.OVERRIDE.MSG SETTING POS2 THEN
                FLAG = 1
            END ELSE
                FLAG =''
                CNT.VALUE = CNT.MSG.VALUE+1
            END
            CNT.VALUE += 1
        REPEAT
        IF FLAG EQ 1 THEN
            MSG.CNT = MSG.FM.CNT+1
        END
    END
RETURN
*---------------------
OFS.CHECK.PROCESS:
*----------------------
    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'FUNDS.TRANSFER,STO.OVERRIDE'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = FT.ID
    OFSRECORD = ''

    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'REDO.OFS.FT.UPDATE'
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
RETURN
*-------------------------------------------------------------------------------------------------------------------------
END
