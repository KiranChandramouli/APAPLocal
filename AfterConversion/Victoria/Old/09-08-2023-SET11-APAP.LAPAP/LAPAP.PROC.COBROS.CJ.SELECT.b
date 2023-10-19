* @ValidationCode : MjotMTEzNDY2MzE1MTpDcDEyNTI6MTY5MTU2NTc5OTE4Mjp2aWN0bzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Aug 2023 12:53:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
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
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*09-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED,$INCLUDE TO $INSERT
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.PROC.COBROS.CJ.SELECT

*-----------------------------------------------------------------------------
* Developed By            : APAP
*
* Developed On            : 23-03-2023
*
* Development Reference   : MDR-2479
*
* Development Description : Recibe los TT de autorizaciones de pago via cobros y los procesa de forma masiva haciendo el pago
*                          que corresponde para el producto castigado , legal ect.
* Attached To             : BATCH>BNK/LAPAP.PROC.COBROS.CJ
*
* Attached As             : Multithreaded Routine
*---------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.REDO.PART.TT.PROCESS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_LAPAP.PROC.COBROS.CJ.COMMON ;*R22 MANUAL CONVERSION END


    GOSUB PROCESO

RETURN

PROCESO:

    CALL F.READ (FN.DIR,Y.INFILE.NAME,R.DIR, FV.DIR, ERROR.DIR)
    IF (R.DIR) THEN
        CALL EB.CLEAR.FILE(FN.LAPAP.COBRO.AUT.WRITE, FV.LAPAP.COBRO.AUT.WRITE)
        SEL.LIST = R.DIR;
        CALL BATCH.BUILD.LIST('',SEL.LIST)
    END

RETURN


END
