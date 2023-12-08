* @ValidationCode : MjozNzQ2NjY2Nzk6Q3AxMjUyOjE3MDIwMzI3NzYwMTc6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Dec 2023 16:22:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*25/05/2023      CONVERSION TOOL         AUTO R22 CODE CONVERSION             NOCHANGE
*25/05/2023      HARISH VIKRAM              MANUAL R22 CODE CONVERSION           NOCHANGE
*08-12-2023     SURESH             R22 MANUAL CODE CONVERISON  OPF TO OPEN
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.B.ADDGEST.CHARGE.LOAD
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ADDGEST.CHARGE.COMMON

****WRITE LOACTION****
    FN.TEMP.FILE.PATH = '&TEMP&'
    OPEN FN.TEMP.FILE.PATH TO F.TEMP.FILE.PATH ELSE
    END
****FILE UPLOAD LOCATION***
    FN.SL = '&SAVEDLISTS&'
    F.SL = ''
    CALL OPF(FN.SL,F.SL)
    OPEN FN.SL TO F.SL ELSE
    END ;*R22 MANUAL CODE CONVERSION
RETURN
END
