* @ValidationCode : MjoyMDc2MDUzNjE3OkNwMTI1MjoxNjgzODkyNjQ0NDA3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.IN.FMT.AMOUNT
************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : H GANESH
* Program Name : REDO.IN.FMT.AMOUNT
*****************************************************************
*Description: This routine is to format the transaction amount
*******************************************************************************
*In parameter : None
*Out parameter : None
****************************************************************************
*Modification History:
**************************
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   5-01-2011       H Ganesh              ODR-2010-08-0469         Initial Creation
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON


 
    GOSUB PROCESS
RETURN


PROCESS:

    Y.AMT=TRIM(Y.FIELD.VALUE[1,10],'0','L'):'.':Y.FIELD.VALUE[11,2]
    Y.FIELD.VALUE=Y.AMT

RETURN
END
