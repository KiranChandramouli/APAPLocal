$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RATE.MON
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
   $USING AA.Framework

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.INTEREST


    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""

    Y.ACC.ID = COMI

    CALL OPF(FN.ACC,FV.ACC)
    CALL F.READ(FN.ACC,Y.ACC.ID,R.ACC,FV.ACC,ACC.ERROR)

    ARRANGEMENT.ID = R.ACC<AC.ARRANGEMENT.ID>

    PROP.CLASS     = ''
    PROP.NAME      = 'PRINCIPALINT'
    RET.ERR        = ''
    R.AA = ''
*    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',R.AA,RET.ERR)
AA.Framework.GetArrangementConditions(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',R.AA,RET.ERR);* R22 UTILITY AUTO CONVERSION

    R.AA = RAISE(R.AA)

    TASA = R.AA<AA.INT.EFFECTIVE.RATE>

    COMI = TASA

END
