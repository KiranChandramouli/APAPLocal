* @ValidationCode : MjoxMjI1OTQ1ODEwOkNwMTI1MjoxNzA0Nzg3NzYyMjA0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 13:39:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CAPL.B.BUILD.LINE.CONT.SELECT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPL.B.BUILD.LINE.CONT.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Batch .SELECT routine, this batch routine takes backup of the record from
*                    the file RE.STAT.LINE.CONT inorder to extract the back dated reports from the system
*Linked With       : Batch BNK/RE.BUILD.SLC
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER      As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 21 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* Date                  who                   Reference
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - VM TO @VM AND SM TO @SM
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT I_REDO.CAPL.B.BUILD.LINE.CONT.COMMON
    $USING EB.Service
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

    REDO.GL.H.EXTRACT.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.GL.H.EXTRACT.PARAMETER

    Y.TOTAL.REPORTS=R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.REPORT.NAME>
    CHANGE @SM TO @VM IN Y.TOTAL.REPORTS
    Y.REP.COUNT = DCOUNT(Y.TOTAL.REPORTS,@VM)
    Y.REP.START = 1

    LOOP
    WHILE Y.REP.START LE Y.REP.COUNT
        LOCATE Y.TOTAL.REPORTS<1,Y.REP.START> IN Y.REP.LIST SETTING Y.REP.POS THEN
            Y.REP.START += 1
            CONTINUE
        END

        Y.REP.LIST<-1> = Y.TOTAL.REPORTS<1,Y.REP.START>
        IF NOT(SEL.CMD) THEN
            SEL.CMD = 'SELECT ':FN.RE.STAT.LINE.CONT:' WITH TYPE EQ DETAIL AND (@ID LIKE ':Y.TOTAL.REPORTS<1,Y.REP.START>:'...'
        END ELSE
            SEL.CMD := ' OR WITH @ID LIKE ':Y.TOTAL.REPORTS<1,Y.REP.START>:'...'
        END
        Y.REP.START += 1
    REPEAT
    SEL.CMD := ") AND (ASST.CONSOL.KEY NE '' OR ASSET.TYPE NE '' OR PROFIT.CCY NE '' OR PRFT.CONSOL.KEY NE '')"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
*********************************
READ.REDO.GL.H.EXTRACT.PARAMETER:
*********************************
* In this para of the code, file REDO.GL.H.EXTRACT.PARAMETER is read
    R.REDO.GL.H.EXTRACT.PARAMETER  = ''
    REDO.GL.H.EXTRACT.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ID,R.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
