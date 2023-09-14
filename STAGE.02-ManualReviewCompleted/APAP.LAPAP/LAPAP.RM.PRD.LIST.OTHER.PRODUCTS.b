* @ValidationCode : MjotMTMxMjExODI5OTpDcDEyNTI6MTY4MjA2ODgxNzY3NjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 14:50:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.RM.PRD.LIST.OTHER.PRODUCTS
*-----------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED, M TO M.VAR
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------

    $INSERT I_COMMON     ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.CR.OTHER.PRODUCTS
    $INSERT I_F.REDO.CUST.PRD.LIST      ;*R22 AUTO CODE CONVERSION.END

    FN.PRD = "F.REDO.CUST.PRD.LIST"
    F.PRD = ""
    CALL OPF(FN.PRD,F.PRD)

    FN.OTHER = "F.CR.OTHER.PRODUCTS"
    F.OTHER = ""
    CALL OPF(FN.OTHER,F.OTHER)

    CUSTOMER = R.NEW(CR.OP.CUSTOMER) ;* 10000013 ;* 1000245
    PRODUCT.ID = ID.NEW

    CALL F.READ(FN.PRD,CUSTOMER,R.PRD,F.PRD,ERR.PRD)
    UU = R.PRD<PRD.PRODUCT.ID>

*-----------------------------------
*This function accept S,R,I,A etc...
*-----------------------------------
    IF V$FUNCTION EQ 'R' THEN

        M.VAR = DCOUNT(UU,@VM)     ;*R22 AUTO CODE CONVERSION
        FOR A = 1 TO M.VAR STEP 1     ;*R22 AUTO CODE CONVERSION
            IF R.PRD<PRD.PRODUCT.ID,A> EQ PRODUCT.ID  THEN

                R.PRD<PRD.PRD.STATUS,A> = "CLOSED"
                CALL F.WRITE(FN.PRD,CUSTOMER,R.PRD)
*               CALL JOURNAL.UPDATE('')

            END
        NEXT A

    END



END
