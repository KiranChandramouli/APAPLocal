* @ValidationCode : MjoxNzM5MzU3MDEwOkNwMTI1MjoxNzAzMjM3NzEwODg4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Dec 2023 15:05:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.B.UPD.OUTS.PRINC.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.B.UPD.OUTS.PRINC.SELECT

*--------------------------------------------------------

*DESCRIBTION: REDO.APAP.B.UPD.OUTS.PRINC.SELECT is the select routine to make a
* select on the REDO.APAP.LOAN.CHEQUE.DETAILS file

*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.APAP.B.UPD.OUTS.PRINC

* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*06.08.2010   H GANESH                ODR-2009-10-0346   INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*22-12-2023      HARISHVIKRAM                 R22 Manual conversion        BATCH.BUILD.LIST
*----------------------------------------------------------------------------------------




*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.APAP.B.UPD.OUTS.PRINC.COMMON
    $USING EB.Service



    GOSUB PROCESS
RETURN

*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------
    SEL.CMD = "SELECT ":FN.REDO.APAP.MORTGAGES.DETAIL
    LIST.PARAMETER ="F.SEL.INT.LIST"
    LIST.PARAMETER<1> = ''
    LIST.PARAMETER<3> = SEL.CMD
*    CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')
    EB.Service.BatchBuildList(LIST.PARAMETER,'')      ;*R22 Manual Conversion
RETURN
END
