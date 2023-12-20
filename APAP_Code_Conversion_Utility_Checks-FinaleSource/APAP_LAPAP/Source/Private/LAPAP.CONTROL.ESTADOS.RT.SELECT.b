* @ValidationCode : Mjo4Mzc4NDk0MDM6Q3AxMjUyOjE2OTAxNjc1NDI1NzU6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:02
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
    $INSERT I_BATCH.FILES
    $INSERT I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT I_F.HOLD.CONTROL
    $INSERT I_CONTROL.ESTADOS.COMMON

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
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

RETURN

END
