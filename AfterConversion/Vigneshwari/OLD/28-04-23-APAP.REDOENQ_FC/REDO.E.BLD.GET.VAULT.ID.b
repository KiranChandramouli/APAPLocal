$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.GET.VAULT.ID(ENQ.DATA)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - CONVERT to CHANGE
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.PARAMETER


*********
PROCESS:
*********
*
    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER = ''
*  CALL OPF(FN.TELLER.PARAMETER, F.TELLER.PARAMETER)

    CALL CACHE.READ(FN.TELLER.PARAMETER, ID.COMPANY, R.TELLER.PARAMETER, TT.PAR.ERR)


    LIST.OF.VAULTS = R.TELLER.PARAMETER<TT.PAR.VAULT.ID>
    CHANGE @VM TO " " IN LIST.OF.VAULTS                  ;*R22 Auto Conversion - CONVERT to CHANGE

    LOCATE "TELLER.ID.2" IN ENQ.DATA<2,1> SETTING POS THEN
        ENQ.DATA<2,POS>    = "NARRATIVE.1"
        ENQ.DATA<3,POS>    = "EQ"
        ENQ.DATA<4,POS>    = LIST.OF.VAULTS
    END ELSE
        ENQ.DATA<2,POS>    = "NARRATIVE.1"
        ENQ.DATA<3,POS>    = "EQ"
        ENQ.DATA<4,POS,1>  = LIST.OF.VAULTS
    END


RETURN
END
