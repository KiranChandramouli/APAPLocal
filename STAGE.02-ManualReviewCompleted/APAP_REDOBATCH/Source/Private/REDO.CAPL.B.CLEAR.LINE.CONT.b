* @ValidationCode : MjotMTQ2NTA1MTcwOkNwMTI1MjoxNjgwNzkwMTEwNzA4OklUU1M6LTE6LTE6ODQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 84
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CAPL.B.CLEAR.LINE.CONT(REDO.CAPL.L.RE.STAT.LINE.CONT.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPL.B.CLEAR.LINE.CONT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a BATCH routine, this batch routine clears the backup taken from
*                    the file RE.STAT.LINE.CONT inorder to extract the back dated reports from the system
*Linked With       : Batch BNK/RE.BUILD.SLC
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.CAPL.L.RE.STAT.LINE.CONT    As              I-O              Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 26 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* 04-APR-2023       Conversion tool    R22 Auto conversion            No changes
* 04-APR-2023        Harishvikram C     Manual R22 conversion        No changes
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
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

    CALL F.DELETE(FN.REDO.CAPL.L.RE.STAT.LINE.CONT,REDO.CAPL.L.RE.STAT.LINE.CONT.ID)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
