* @ValidationCode : MjotNTc0NTQxMTcxOkNwMTI1MjoxNjk4MzEyMjUyMzk4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 14:54:12
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
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>199</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE V.TFS.STO.TIDYUP.BENEFICIARY
*
* When defining STO.BULK.CODE, the last multi value in BENEFICIARY field
* will be populated with a Susp Category
*
* When the address details are populated into STO, we need to remove that categ
* from BENEFICIARY field and thats what this routine does.
*
* Attached as INPUT.RTN to STANDING.ORDER,T24.FS Version.
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion                 Nochange
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDING.ORDER

    IF APPLICATION NE 'STANDING.ORDER' THEN RETURN

    BENEFICIARY = R.NEW(STO.BENEFICIARY)
* Tidy-Up Beneficiary
    NO.OF.VMS = DCOUNT(BENEFICIARY,@VM)
    POSSIBLE.CATEG = BENEFICIARY<1,NO.OF.VMS>
    DEL.BENE = 0
    IF POSSIBLE.CATEG EQ 'XXXXXXXXXXX' THEN
        DEL.BENE = 1
    END ELSE
        FN.CATEG = 'F.CATEGORY' ; F.CATEG = ''
        CALL F.READ(FN.CATEG,POSSIBLE.CATEG,R.CATEG,F.CATEG,ERR.CATEG)
        IF R.CATEG THEN
            DEL.BENE = 1
        END
    END
    IF DEL.BENE THEN DEL BENEFICIARY<1,NO.OF.VMS>
*
RETURN
*------------------------------------------------------------------------------
END
