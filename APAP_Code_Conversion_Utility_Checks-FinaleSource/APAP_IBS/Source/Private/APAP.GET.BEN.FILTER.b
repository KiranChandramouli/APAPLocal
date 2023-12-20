* @ValidationCode : MjoxMDgwODc3MzA5OkNwMTI1MjoxNjk4NDA1NTM4MDI0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:58
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
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE APAP.GET.BEN.FILTER(ID.LIST)
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                Remove APAP.BP FROM INSERT FILE
*-----------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Description :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.BENEFICIARY
    $INSERT I_EB.MOB.FRMWRK.COMMON  ;* MANUAL R23 CODE CONVERSION - Remove APAP.BP FROM INSERT FILE,VM TO @VM
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


    RETURN

*-----------------------------------------------------------------------------
PROCESS:

*    READ R.BEN.CUST FROM F.BEN.OWN.CUST, CUST.ID THEN
*        ID.LIST = FIELDS(R.BEN.CUST, '*', 2)
*    END

    FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
    F.CUS.BEN.LIST  = ''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)


    CUS.BEN.LIST.ID = CUST.ID:'-OWN'
    CUS.BEN.LIST.ER =""
    R.CUS.BEN.LIST=""
    CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)

    IF NOT(CUS.BEN.LIST.ER) THEN

        LOOP

            REMOVE BEN.EACH.ID FROM R.CUS.BEN.LIST SETTING BEN.LIST.POS
        WHILE BEN.EACH.ID:BEN.LIST.POS
            BEN.ID = FIELD(BEN.EACH.ID,"*",2)
            ID.LIST<-1> = BEN.ID


        REPEAT
    END

    CUS.BEN.LIST.ID = CUST.ID:'-OTHER'
    CUS.BEN.LIST.ER =""
    R.CUS.BEN.LIST=""
    CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)

    IF NOT(CUS.BEN.LIST.ER) THEN

        LOOP

            REMOVE BEN.EACH.ID FROM R.CUS.BEN.LIST SETTING BEN.LIST.POS
        WHILE BEN.EACH.ID:BEN.LIST.POS
            BEN.ID = FIELD(BEN.EACH.ID,"*",2)
            ID.LIST<-1> = BEN.ID


        REPEAT
    END

*    SEL.CMD = 'SELECT ':FN.BENEFICIARY:' WITH OWNING.CUSTOMER EQ ':SQUOTE(CUST.ID)
*    EXECUTE SEL.CMD CAPTURING SEL.OUT

*    READLIST ID.LIST ELSE ID.LIST = ''

    RETURN

*-----------------------------------------------------------------------------
END
