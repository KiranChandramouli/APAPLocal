* @ValidationCode : MjotMTE4NTg2MDQwMDpDcDEyNTI6MTY4NTAwMDA1NTIzOTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 May 2023 13:04:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.B.ADDGEST.CORRECT.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* *Modification History
*DATE                       WHO                         REFERENCE                DESCRIPTION
*25-05-2023           Conversion Tool          R22 Auto Code conversion             No Changes
*25-05-2023           Harish vikaram C             Manual R22 Code Conversion         No Changes
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ADDGEST.CORRECT.COMMON

****WRITE LOACTION****
    FN.TEMP.FILE.PATH = '&TEMP&'
    OPEN FN.TEMP.FILE.PATH TO F.TEMP.FILE.PATH ELSE
    END
****FILE UPLOAD LOCATION***
    FN.SL = '&SAVEDLISTS&'
    F.SL = ''
    CALL OPF(FN.SL,F.SL)

    FN.AA.REF = "F.AA.ARRANGEMENT.DATED.XREF"
    F.AA.REF = ""
    CALL OPF(FN.AA.REF,F.AA.REF)

RETURN
END
