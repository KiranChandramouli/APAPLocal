*-----------------------------------------------------------------------------
* <Rating>-51</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.ENQ.GET.CUST.PHONE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB MULTI.GET.LOC.REF
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
PROCESS:

    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUS.REC,F.CUSTOMER,CUS.ERR)
    IF R.CUS.REC THEN
        LOCATE 'HOME PHONE' IN R.CUS.REC<EB.CUS.LOCAL.REF,CONTACT.TYPE.POS,1> SETTING POS THEN
            Y.HOME.PHONE = R.CUS.REC<EB.CUS.LOCAL.REF,CONTACT.DETAIL.POS,POS>
        END
        LOCATE 'OFFICE PHONE' IN R.CUS.REC<EB.CUS.LOCAL.REF,CONTACT.TYPE.POS,1> SETTING POS THEN
            Y.OFF.PHONE = R.CUS.REC<EB.CUS.LOCAL.REF,CONTACT.DETAIL.POS,POS>
        END
        LOCATE 'MOBILE PHONE' IN R.CUS.REC<EB.CUS.LOCAL.REF,CONTACT.TYPE.POS,1> SETTING POS THEN
            Y.MOB.PHONE = R.CUS.REC<EB.CUS.LOCAL.REF,CONTACT.DETAIL.POS,POS>
        END
    END
    O.DATA=''
    IF Y.HOME.PHONE THEN
        O.DATA<1,-1> = "Home: ":Y.HOME.PHONE
    END
    IF Y.OFF.PHONE THEN
        O.DATA<1,-1> = "Office: ":Y.OFF.PHONE
    END
    IF Y.MOB.PHONE THEN
        O.DATA <1,-1> = "Mobile: ":Y.MOB.PHONE
    END
    VM.COUNT = DCOUNT(O.DATA,VM)

    RETURN
*-----------------------------------------------------------------------------
*/////////////////////////////////////////////////////////////////////////////
*////////////////P R E  P R O C E S S  S U B R O U T I N E S /////////////////
*/////////////////////////////////////////////////////////////////////////////
*-----------------------------------------------------------------------------
INITIALISE:

    Y.CUS.ID = O.DATA
    R.CUS.REC = ''
    Y.HOME.PHONE = ''
    Y.OFF.PHONE = ''
    Y.MOB.PHONE = ''
    RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    RETURN
*-----------------------------------------------------------------------------
MULTI.GET.LOC.REF:

    LR.APP = 'CUSTOMER'
    LR.FLD = 'CONTACT.TYPE':VM:'CONTACT.DETAIL'
    LR.POS=''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLD,LR.POS)
    CONTACT.TYPE.POS = LR.POS<1,1>
    CONTACT.DETAIL.POS = LR.POS<1,2>

    RETURN
*-----------------------------------------------------------------------------
END



