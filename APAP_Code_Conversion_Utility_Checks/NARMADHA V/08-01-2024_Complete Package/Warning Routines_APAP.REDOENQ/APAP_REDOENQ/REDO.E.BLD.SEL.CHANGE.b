* @ValidationCode : MjotMjk5NjgzMDU4OlVURi04OjE3MDMyNTM1MDk4NTA6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Dec 2023 19:28:29
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.SEL.CHANGE(ENQ.DATA)

*----------------------------------------------------------------------------------------------------------------------
* DESCRIPTION : ROUTINE TO MODIFY THE SELECTION CRITERIA TO REMOVE THE B.29 DEPOSIT TILL FROM THE ENQ O/P
*
*----------------------------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*----------------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : VIGNESH KUMAAR M R
* PROGRAM NAME : REDO.E.BLD.SEL.CHANGE
*----------------------------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------------------------
* DATE          AUTHOR                REFERENCE        DESCRIPTION
* 09/07/2013    VIGNESH KUMAAR M R    PACS00306444     SEL CONDITION TO REMOVE THE B.29 TILL
* 12/07/2013    VIGNESH KUMAAR M R    PACS00307024     SELECTION TO BE BASED ON THE COMPANY
* 17-APR-2023     Conversion tool   R22 Auto conversion   VM to @VM
* 17-APR-2023      Harishvikram C   Manual R22 conversion     No changes
* 22-12-2023       Narmadha V        Manual R22 Conversion  Changed ID Variable instead of Hardcoding
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.AZ.FUND.PARAM

* Fix for PACS00306444 [SEL CONDITION TO REMOVE THE B.29 TILL]

    IF ENQ.DATA<1> EQ 'REASSIGN.TILL' THEN

        FN.REDO.AZ.FUND.PARAM = 'F.REDO.AZ.FUND.PARAM'
        F.REDO.AZ.FUND.PARAM = ''
*    CALL OPF(FN.REDO.AZ.FUND.PARAM,F.REDO.AZ.FUND.PARAM)

        Y.ID = "SYSTEM"
*    CALL F.READ(FN.REDO.AZ.FUND.PARAM,'SYSTEM',R.REDO.AZ.FUND.PARAM,F.REDO.AZ.FUND.PARAM,REDO.AZ.FUND.PARAM.ERR) ;*Tus Start
* CALL CACHE.READ(FN.REDO.AZ.FUND.PARAM,'SYSTEM',R.REDO.AZ.FUND.PARAM,REDO.AZ.FUND.PARAM.ERR) ; * Tus End
        CALL CACHE.READ(FN.REDO.AZ.FUND.PARAM,Y.ID,R.REDO.AZ.FUND.PARAM,REDO.AZ.FUND.PARAM.ERR) ;*Manual R22 Conversion - Changed ID Variable instead of Hardcoding
        NON.TT.USER = R.REDO.AZ.FUND.PARAM<REDO.FUND.OFS.USER>

        Y.CNT = DCOUNT(ENQ.DATA<2>,@VM)
        LOCATE 'K.USER' IN ENQ.DATA<2,1> SETTING USER.POS THEN
            Y.FIX.SEL.CNT = DCOUNT(R.ENQ<3>,@VM)
            R.ENQ<3,Y.FIX.SEL.CNT+1> = 'K.USER NE ':NON.TT.USER
        END ELSE
            Y.POS = Y.CNT + 1
            ENQ.DATA<2,Y.POS> = 'K.USER'
            ENQ.DATA<3,Y.POS> = 'NE'
            ENQ.DATA<4,Y.POS> = NON.TT.USER
        END
        RETURN
    END

* End of Fix

* Fix for PACS00307024 [SELECTION TO BE BASED ON THE COMPANY]

    IF ENQ.DATA<1> EQ 'REDO.ENQ.TELLER.ID' THEN

* Confirmed with Bank user's TELLER information will be displayed regardless of the Branch
*        LOCATE 'TELLER.ID' IN ENQ.DATA<2,1> SETTING TILL.POS THEN
*           Y.TELLER.ID = ENQ.DATA<4,TILL.POS>
*            Y.TILL.VAL = Y.TELLER.ID[1,2]
*
*           IF ID.COMPANY[8,2] NE Y.TILL.VAL THEN
*               ENQ.ERROR = 'EB-REDO.NO.OTHER.BRANCH.ACCESS'
*            END
*       END

        LOCATE 'PAY.COMPANY' IN ENQ.DATA<2,1> SETTING PAY.POS ELSE
            ENQ.DATA<2,-1> = 'PAY.COMPANY'
            ENQ.DATA<3,-1> = 'EQ'
            ENQ.DATA<4,-1> = ID.COMPANY
        END
    END

* End of Fix

RETURN
