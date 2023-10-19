* @ValidationCode : MjotODc2Mzg1NjE1OkNwMTI1MjoxNjgyNDEyMzQ0ODg2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:44
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.CHK.OTH.TT.BOX
*----------------------------------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS
*----------------------------------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : Vignesh Kumaar M R
* PROGRAM NAME : REDO.V.CHK.OTH.TT.BOX
*
*----------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE          WHO                   REFERENCE       DESCRIPTION
*
* 11/04/2013    Vignesh Kumaar M R    PACS00251345    Tax Excemption getting reassigned to NO during validate
* 09/05/2013    Vignesh Kumaar M R    PACS00266084    Should not allow reverse/input of other TT BOX TXN
* 05/08/2013    Vignesh Kumaar M R    PACS00265089    Update the error msg EB-ONLY.SAME.OPERATOR.AMEND
* 10/04/2014    Vignesh Kumaar M R    PACS00349444    Shouldn't allow user to amend the record [updated]
*Modification history
*Date                Who               Reference                  Description
*13-04-2023      conversion tool     R22 Auto code conversion     FM TO @FM
*13-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.TELLER

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.NAU = 'F.TELLER$NAU'
    F.TELLER.NAU = ''
    CALL OPF(FN.TELLER.NAU,F.TELLER.NAU)

* Fix for PACS00265093/PACS00266084 [Should not allow reverse/input of other TT BOX TXN]

    CALL F.READ(FN.TELLER.NAU,COMI,R.TELLER,F.TELLER.NAU,TELLER.ERR)

    IF V$FUNCTION EQ 'I' AND R.TELLER NE '' AND OFS$SOURCE.ID NE 'FASTPATH' THEN
        E = 'EB-CANNOT.AMEND.EXISTING.RECORD'         ;* Fix for PACS00349444
        CALL ERR
    END

    IF R.TELLER EQ '' THEN
        CALL F.READ(FN.TELLER,COMI,R.TELLER,F.TELLER,TELLER.ERR)
    END

    IF (V$FUNCTION EQ 'R' OR V$FUNCTION EQ 'I') AND R.TELLER NE '' THEN

        SET.USER.FLAG = ''

        GET.INPUTTER = R.TELLER<TT.TE.INPUTTER>
        GET.TT.USER = FIELDS(GET.INPUTTER,'_',2)
        IF GET.TT.USER EQ OPERATOR THEN
            SET.USER.FLAG = 1
        END

        IF NOT(SET.USER.FLAG) THEN

            IF V$FUNCTION EQ 'I' THEN
                E = 'EB-ONLY.SAME.OPERATOR.AMEND':@FM:GET.TT.USER    ;* Fix for PACS00265089
            END ELSE
                E = 'TT-REDO.TXN.OTHER.BOX'
            END
            CALL ERR
        END
    END

* End of Fix

RETURN
*
