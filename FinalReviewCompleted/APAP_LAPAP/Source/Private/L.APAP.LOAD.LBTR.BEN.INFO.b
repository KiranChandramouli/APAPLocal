$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.LOAD.LBTR.BEN.INFO
*--------------------------------------------------------------------------------------------------
* Description           : Esta rutina carga a la version la informacion de un beneficiario
* Developed On          : ---
* Developed By          : Anthony Martinez
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Anthony Martinez               04/01/2019            Creation
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes   
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CUSTOMER

    Y.BEN.ID = R.NEW(FT.CREDIT.THEIR.REF)

*-- GET BENEFICIARY DATA
    FN.BEN = "F.BENEFICIARY"; FV.BEN = ""; R.BEN = ""; ERR.BEN = ""
    CALL OPF(FN.BEN, FV.BEN)
    CALL CACHE.READ(FN.BEN, Y.BEN.ID, R.BEN, ERR.BEN)	;*R22 Auto Conversion  - F.READ to CACHE.READ

    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FTST.ACH.PART", L.FTST.ACH.PART.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.CUST.NAME", L.BEN.CUST.NAME.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.CEDULA", L.BEN.CEDULA.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.ACCOUNT", L.BEN.ACCOUNT.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.BANK", L.BEN.BANK.POS)
    CALL GET.LOC.REF("BENEFICIARY", "L.BEN.PROD.TYPE", L.BEN.PROD.TYPE.POS)

    Y.BANK.CODE = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.BANK.POS, 1>
    Y.PROD.TYPE = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.PROD.TYPE.POS, 1>
    Y.BK.TO.BK.OUT = ''

*-- GET CUSTOMER DATA
    FN.CUS = "F.CUSTOMER"; FV.CUS = ""; R.CUS = ""; ERR.CUS = ""
    CALL OPF(FN.CUS, FV.CUS)
    CALL F.READ(FN.CUS, R.BEN<ARC.BEN.OWNING.CUSTOMER>, R.CUS, FV.CUS, ERR.CUS)

*-- GET BANKS DATA
    FN.BANKS = "F.REDO.ACH.PARTICIPANTS"; FV.BANKS = ""; R.BANKS = ""; ERR.BANKS = ""
    CALL OPF(FN.BANKS, FV.BANKS)
    CALL F.READ(FN.BANKS, Y.BANK.CODE, R.BANKS, FV.BANKS, ERR.BANKS)

    Y.CUS.DATA = R.CUS<EB.CUS.GIVEN.NAMES> : " " : R.CUS<EB.CUS.FAMILY.NAME> : @VM : R.CUS<EB.CUS.STREET> : @VM : R.CUS<EB.CUS.TOWN.COUNTRY> : @VM : R.CUS<EB.CUS.COUNTRY>

    R.NEW(FT.ACCT.WITH.BANK) = "SW." : R.BANKS<4>
    R.NEW(FT.ORDERING.CUST)  = Y.CUS.DATA
    R.NEW(FT.BEN.CUSTOMER)   = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.CUST.NAME.POS, 1> : @VM : R.BEN<ARC.BEN.LOCAL.REF, L.BEN.CEDULA.POS, 1>
    R.NEW(FT.BEN.ACCT.NO)    = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.ACCOUNT.POS, 1>
    R.NEW(FT.LOCAL.REF)<1, L.FTST.ACH.PART.POS> = Y.BANK.CODE

RETURN

END
