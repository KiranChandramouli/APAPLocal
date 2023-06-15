* @ValidationCode : MjotNDU1NzkyODI6Q3AxMjUyOjE2ODQ4MzYwNDE5Nzg6SVRTUzotMTotMToxOTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 190
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.INP.CONV.NAME
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    : REDO.APAP.INP.CONV.NAME
*Reference Number  : ODR-2010-08-0179
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the name and format them
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.SOLICITUD.CK
 
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

OPENFILE:
    FN.REDO.H.SOLICITUD.CK = 'F.REDO.H.SOLICITUD.CK'
    F.REDO.H.SOLICITUD.CK = ''
    CALL OPF(FN.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK)

PROCESS:

    CALL F.READ(FN.REDO.H.SOLICITUD.CK,ID,R.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK,SOLICITUD.ERR)
    VAR.NAME = R.REDO.H.SOLICITUD.CK<REDO.H.SOL.INPUTTER>
    O.DATA = FIELD(VAR.NAME,'_',2)

RETURN
END
