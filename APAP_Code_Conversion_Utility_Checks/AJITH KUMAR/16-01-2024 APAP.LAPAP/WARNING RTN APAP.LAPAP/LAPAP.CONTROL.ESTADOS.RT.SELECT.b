* @ValidationCode : MjoxNDg5Mjc5NTAxOkNwMTI1MjoxNzA0ODA1MzAwMjY5OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 18:31:40
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CONTROL.ESTADOS.RT.SELECT

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
   * $INSERT I_BATCH.FILES
    $INSERT I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT I_F.HOLD.CONTROL
    $INSERT I_CONTROL.ESTADOS.COMMON
   $USING EB.Service

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST

    END
    GOSUB SELECCIONAR
RETURN

BUILD.CONTROL.LIST:
*******************

    CONTROL.LIST<-1> = "SELECT.HC"
    CONTROL.LIST<-1> = "SELECT.EC"
RETURN


SELECCIONAR:
    LIST.PARAMETER = ""

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.HC"
            LIST.PARAMETER<2> = "F.HOLD.CONTROL"
            LIST.PARAMETER<3> = "REPORT.NAME EQ ACCOUNT.STATEMENT AND BANK.DATE EQ " : TODAY
            CALL OCOMO ("VALOR DEL LISTA HC :" : LIST.PARAMETER)
        CASE CONTROL.LIST<1,1> EQ "SELECT.EC"
            LIST.PARAMETER = ""
            LIST.PARAMETER<2> = "FBNK.ST.LAPAP.CONTROL.ESTADOS"
            LIST.PARAMETER<3> = "BANK.DATE LT " : OLD.DATE
            CALL OCOMO ("VALOR DEL LISTA EC :" : LIST.PARAMETER)
    END CASE
*    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION

RETURN

END
