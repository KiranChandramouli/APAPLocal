* @ValidationCode : Mjo3MDQyMDA1OTc6Q3AxMjUyOjE3MDM1NjQyMzI2NjM6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 09:47:12
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
SUBROUTINE REDO.B.COM.RISK.GROUP.SELECT
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Thenmalar T, Capgemini
*
* Development Reference : REGN3-GR01
*
* Attached To           : Batch - BNK/REDO.B.COM.RISK.GROUP
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
*-----------------------------------------------------------------------------------------------------------------
* REGN3-GR02             Thenmalar T                    2014-02-20           Initial Draft
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION  FM TO @FM
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion  CALL routine modified
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.COM.RISK.GROUP.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    
    $USING EB.Service ;*R22 Manual Conversion

*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = CURR.MONTH + 1 - 1

    LOCATE CURR.MONTH IN FIELD.GEN.VAL<1> SETTING FOUND.POS ELSE
        RETURN
    END

    FN.CHK.DIR=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    EXTRACT.FILE.ID=R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>:'_': R.DATES(EB.DAT.LAST.WORKING.DAY) : '.csv'

    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
    Y.SEL.REL.LIST=Y.REV.REL.CODE.LIST
    CHANGE @FM TO ' ' IN Y.SEL.REL.LIST

    SEL.CMD = "SELECT ":FN.RELATION.CUSTOMER:" WITH IS.RELATION EQ ":Y.SEL.REL.LIST
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 Manual Conversion

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
