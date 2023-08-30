* @ValidationCode : MjoxNzA1ODQ5NzUzOkNwMTI1MjoxNjgxMzY0NTIxNDQwOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 11:12:01
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
SUBROUTINE REDO.B.UPD.APAP.ACCOUNT.ACT
*********************************************************************************************************
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : Temenos Application Management
* Program   Name    : REDO.B.UPD.APAP.ACCOUNT.ACT
*--------------------------------------------------------------------------------------------------------
* Description       : REDO.B.UPD.APAP.ACCOUNT.ACT is an BATCH routine ,
*                   : select the table account.act , and update the local table
*                   * REDO.APAP.ACCOUNT.ACT with @ID as date and field values as account numbers
*--------------------------------------------------------------------------------------------------------
* Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 20-Jun-2013        Arundev KR               PACS00293038              Initial Creation
* 12-Feb-2014     V.P.Ashokkumar              PACS00309822              Added new field to capture curr no
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.ACCOUNT.ACT

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    R.REDO.APAP.ACCOUNT.ACT = ''
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------

    FN.ACCOUNT.ACT = 'F.ACCOUNT.ACT'
    F.ACCOUNT.ACT = ''
    CALL OPF(FN.ACCOUNT.ACT,F.ACCOUNT.ACT)

    FN.REDO.APAP.ACCOUNT.ACT = 'F.REDO.APAP.ACCOUNT.ACT'
    F.REDO.APAP.ACCOUNT.ACT =''
    CALL OPF(FN.REDO.APAP.ACCOUNT.ACT,F.REDO.APAP.ACCOUNT.ACT)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    SEL.LIST = ''
    SELECT.CMD = 'SELECT ':FN.ACCOUNT.ACT:' BY @ID'
    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,RC)

    POS1 = ''
    PREV.ACCOUNT.NO = ''
    LOOP
        REMOVE ACCOUNT.HIST.NO FROM SEL.LIST SETTING POS1
    WHILE ACCOUNT.HIST.NO:POS1
        AC.CURR.NO = ''; YDTE.CURR = '' ; ACCOUNT.NO = ''
        ACCOUNT.NO = FIELD(ACCOUNT.HIST.NO,';',1)
        AC.CURR.NO = FIELD(ACCOUNT.HIST.NO,';',2)
        YDTE.CURR = ACCOUNT.NO:"*":TODAY:"*":AC.CURR.NO
        IF PREV.ACCOUNT.NO NE ACCOUNT.NO THEN
            R.REDO.APAP.ACCOUNT.ACT<REDO.ACC.ACT.ACCT.NO,-1> = ACCOUNT.HIST.NO
            R.REDO.APAP.ACCOUNT.ACT<REDO.ACC.ACT.ACCT.DATE.CURR,-1> = YDTE.CURR
        END
        PREV.ACCOUNT.NO = ACCOUNT.NO
    REPEAT

    CALL F.WRITE(FN.REDO.APAP.ACCOUNT.ACT,TODAY,R.REDO.APAP.ACCOUNT.ACT)

RETURN
*---------------------------------------------------------------------------------
END
