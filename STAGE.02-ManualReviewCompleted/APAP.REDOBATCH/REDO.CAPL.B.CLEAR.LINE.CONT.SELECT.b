* @ValidationCode : MjotMTc4NDQ2NTg1MDpDcDEyNTI6MTY4MTc5NDY0NDE3NTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:40:44
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
SUBROUTINE REDO.CAPL.B.CLEAR.LINE.CONT.SELECT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPL.B.CLEAR.LINE.CONT.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Batch .SELECT routine, this batch routine clears the backup taken from
*                    the file RE.STAT.LINE.CONT inorder to extract the back dated reports from the system
*Linked With       : Batch BNK/RE.BUILD.SLC
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 26 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - SM TO @SM AND VM TO @VM
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT I_F.REDO.CAPL.L.RE.STAT.LINE.CONT
    $INSERT I_REDO.CAPL.B.CLEAR.LINE.CONT.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.RETENTION.DATE = TODAY
    Y.TOTAL.REPORTS=R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.REPORT.NAME>
    CHANGE @SM TO @VM IN Y.TOTAL.REPORTS

    Y.REP.COUNT = DCOUNT(Y.TOTAL.REPORTS,@VM)
    Y.REP.START = 1

    LOOP
    WHILE Y.REP.START LE Y.REP.COUNT
        LOCATE Y.TOTAL.REPORTS<1,Y.REP.START> IN Y.PROCESSED.RPT.IDS SETTING Y.PROCESS.REP.POS ELSE
            Y.PROCESSED.RPT.IDS<-1>=Y.TOTAL.REPORTS<1,Y.REP.START>
            GOSUB FORM.SELECT.CMD
        END
        Y.REP.START += 1
    REPEAT

    CALL BATCH.BUILD.LIST('',Y.PROCESSED.IDS)

RETURN
*--------------------------------------------------------------------------------------------------------
****************
FORM.SELECT.CMD:
****************

    Y.REP.NAME   = Y.TOTAL.REPORTS<1,Y.REP.START>
    Y.RET.PERIOD = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RETEN.PERIOD,Y.REP.START>

    BEGIN CASE

        CASE Y.RET.PERIOD EQ "DAY"
            CALL CDT('',Y.RETENTION.DATE,'-1W')

        CASE Y.RET.PERIOD EQ "WEEK"
            CALL CDT('',Y.RETENTION.DATE,'-5W')

        CASE Y.RET.PERIOD EQ "FORTNIGHT"
            CALL CDT('',Y.RETENTION.DATE,'-10W')

        CASE Y.RET.PERIOD EQ "MONTH"
            CALL CDT('',Y.RETENTION.DATE,'-20W')

        CASE Y.RET.PERIOD EQ "QUARTER"
            CALL CDT('',Y.RETENTION.DATE,'-60W')

        CASE Y.RET.PERIOD EQ "HALF YEAR"
            CALL CDT('',Y.RETENTION.DATE,'-120W')

        CASE 1
            CALL CDT('',Y.RETENTION.DATE,'-1W')

    END CASE

    SEL.CMD = 'SELECT ':FN.REDO.CAPL.L.RE.STAT.LINE.CONT:' WITH @ID LIKE ':Y.REP.NAME:'... AND DATE.UPDATED LE ':Y.RETENTION.DATE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    IF SEL.LIST THEN
        GOSUB GET.PROCESSED.IDS
    END

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.PROCESSED.IDS:
******************
    IF NOT(Y.PROCESSED.IDS) THEN
        Y.PROCESSED.IDS = SEL.LIST
        RETURN
    END

    LOOP
        REMOVE Y.REC.ID FROM SEL.LIST SETTING Y.REC.POS
    WHILE Y.REC.ID : Y.REC.POS
        LOCATE Y.REC.ID IN Y.PROCESSED.IDS<1> SETTING Y.PROCESS.POS ELSE
            Y.PROCESSED.IDS<-1> = Y.REC.ID
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
