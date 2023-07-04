* @ValidationCode : MjoxMzYzMjI1MTU0OkNwMTI1MjoxNjg0ODU0Mzg5NDM2OklUU1M6LTE6LTE6Mzc0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 374
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LIST.OF.SHAREHOLDER.SELECT
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786922-217-MV32
*
* Attached To           : Batch - BNK/REDO.B.LIST.OF.SHAREHOLDER
*
* Attached As           : Multi Threaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
* Date                   who                   Reference              
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM AND FM TO @FM
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.DATES
    $INSERT I_REDO.B.LIST.OF.SHAREHOLDER.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**
    GOSUB CHECK.GEN.FILE
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------

*--------------
CHECK.GEN.FILE:
*--------------

    FN.CHK.DIR=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    EXTRACT.FILE.ID=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>:'_': R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID

    END

RETURN
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = TRIM(CURR.MONTH,'0','L')

    LOCATE CURR.MONTH IN REP.GEN.MONTHS<1,1,1> SETTING FOUND.POS ELSE
        RETURN
    END

*    SEL.CMD = 'SELECT ':FN.RELATION.CUSTOMER
*    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    CALL F.READ(FN.RELATION.CUSTOMER,Y.APAP.CUST.NO,R.APAP.RC,F.RELATION.CUSTOMER,Y.APAP.CUS.ERR)

    SEL.LIST=R.APAP.RC<EB.RCU.OF.CUSTOMER>
    CHANGE @VM TO @FM IN SEL.LIST
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
