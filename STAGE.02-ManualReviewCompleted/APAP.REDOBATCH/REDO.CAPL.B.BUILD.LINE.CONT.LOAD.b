* @ValidationCode : MjotNzU4NjU5NzU0OkNwMTI1MjoxNjgxNzk0NTQyODM5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:39:02
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
SUBROUTINE REDO.CAPL.B.BUILD.LINE.CONT.LOAD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPL.B.BUILD.LINE.CONT.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Batch .LOAD routine, this batch routine takes backup of the record from
*                    the file RE.STAT.LINE.CONT inorder to extract the back dated reports from the system
*Linked With       : Batch BNK/RE.BUILD.SLC
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER      As              I               Mode
*                    RE.STAT.LINE.CONT                As              I               Mode
*                    REDO.CAPL.L.RE.STAT.LINE.CONT    As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 21 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT I_F.REDO.CAPL.L.RE.STAT.LINE.CONT
    $INSERT I_REDO.CAPL.B.BUILD.LINE.CONT.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
    F.REDO.GL.H.EXTRACT.PARAMETER = ''
    CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

    FN.RE.STAT.LINE.CONT = 'F.RE.STAT.LINE.CONT'
    F.RE.STAT.LINE.CONT = ''
    CALL OPF(FN.RE.STAT.LINE.CONT,F.RE.STAT.LINE.CONT)

    FN.REDO.CAPL.L.RE.STAT.LINE.CONT = 'F.REDO.CAPL.L.RE.STAT.LINE.CONT'
    F.REDO.CAPL.L.RE.STAT.LINE.CONT = ''
    CALL OPF(FN.REDO.CAPL.L.RE.STAT.LINE.CONT,F.REDO.CAPL.L.RE.STAT.LINE.CONT)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
