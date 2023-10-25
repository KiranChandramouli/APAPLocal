$PACKAGE APAP.IBS
* @ValidationCode : MjotMjEwMTkzMTc5NjpDcDEyNTI6MTY5ODIzNDg1ODUyOTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Oct 2023 17:24:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.


*-----------------------------------------------------------------------------
* <Rating>-25</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE APAP.GET.CERITOS.TOT.FILTRE(ID.LIST)
*-----------------------------------------------------------------------------
* Description :
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion             APAP.BP File Removed
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_EB.MOB.FRMWRK.COMMON ;*R22 Manual Conversion
*-----------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
INITIALISE:

*    FN.BEN.OWN.CUST = 'F.BENEFICIARY.OWNING.CUSTOMER'
*    F.BEN.OWN.CUST = ''
*    CALL OPF(FN.BEN.OWN.CUST, F.BEN.OWN.CUST)

    IF NOT(ID.LIST) THEN
        CUST.ID = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>
    END ELSE
        CUST.ID = ID.LIST
    END

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY = ''
    CALL OPF(FN.BENEFICIARY, F.BENEFICIARY)

    FN.REDO.LY.POINTS.TOT = "F.REDO.LY.POINTS.TOT"
    F.REDO.LY.POINTS.TOT=""
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

RETURN

*-----------------------------------------------------------------------------
PROCESS:

*    READ R.BEN.CUST FROM F.BEN.OWN.CUST, CUST.ID THEN
*        ID.LIST = FIELDS(R.BEN.CUST, '*', 2)
*    END
    ID.LIST = ""
    Y.CURR.YEAR = TODAY[1,4]
    Y.START.YEAR = 2015
    FOR I = Y.START.YEAR TO Y.CURR.YEAR
        REDO.LY.POINTS.TOT.ID=CUST.ID:'PL00001ALL':I
        Y.ERR=""
        CALL F.READ(FN.REDO.LY.POINTS.TOT, REDO.LY.POINTS.TOT.ID, R.REDO.LY.POINTS.TOT, F.REDO.LY.POINTS.TOT,Y.ERR)
        IF NOT(Y.ERR) THEN
            ID.LIST<-1>  = REDO.LY.POINTS.TOT.ID
        END
    NEXT I
RETURN

*-----------------------------------------------------------------------------
END
