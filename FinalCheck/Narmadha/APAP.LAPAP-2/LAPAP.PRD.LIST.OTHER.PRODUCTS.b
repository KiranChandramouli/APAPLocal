* @ValidationCode : MjotMTc2MjYxMzI4OTpDcDEyNTI6MTY4MjA3OTg0NDUxNzpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:54:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PRD.LIST.OTHER.PRODUCTS
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE          WHO                 REFERENCE               DESCRIPTION
    
* 21-APR-2023   Conversion tool    R22 Auto conversion      BP is removed in Insert File, M to M.VAR
* 21-APR-2023   Narmadha V         R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.CR.OTHER.PRODUCTS
    $INSERT I_F.REDO.CUST.PRD.LIST ;*R22 Auto conversion - END


    FN.PRD = "F.REDO.CUST.PRD.LIST"
    F.PRD = ""
    CALL OPF(FN.PRD,F.PRD)

    FN.OTHER = "F.CR.OTHER.PRODUCTS"
    F.OTHER = ""
    CALL OPF(FN.OTHER,F.OTHER)

    CUSTOMER  = COMI
    PRODUCT = ID.NEW
    ARR<PRD.PRODUCT.ID> = PRODUCT
    ARR<PRD.PRD.STATUS> = "ACTIVE"
    ARR<PRD.TYPE.OF.CUST> = "CUSTOMER"
    ARR<PRD.DATE> = TODAY
    ARR<PRD.PROCESS.DATE> = TODAY


    CALL F.READ(FN.PRD,CUSTOMER,R.PRD,F.PRD,ERR.PRD)
    UU = R.PRD<PRD.PRODUCT.ID>

    M.VAR = DCOUNT(UU,@VM)
    P = M.VAR+1

    IF R.PRD<PRD.PRODUCT.ID,M.VAR> NE PRODUCT THEN

        R.PRD<PRD.PRODUCT.ID,P> = PRODUCT
        R.PRD<PRD.PRD.STATUS,P> = "ACTIVE"
        R.PRD<PRD.TYPE.OF.CUST,P> = "CUSTOMER"
        R.PRD<PRD.DATE,P> = TODAY


        IF ERR.PRD THEN
            CALL F.WRITE(FN.PRD,CUSTOMER,ARR)
        END

        IF ERR.PRD EQ "" THEN
            CALL F.WRITE(FN.PRD,CUSTOMER,R.PRD)
            RETURN
        END


*   CALL JOURNAL.UPDATE('')

    END

RETURN


END
