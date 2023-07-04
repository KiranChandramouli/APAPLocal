$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.GET.VERSION.NAME
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM and F.READ to CACHE.READ
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.ENQUIRY


    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------
OPEN.FILES:
*--------------

    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)

    FN.BRANCH.UNAUTH.LIST = 'F.BRANCH.UNAUTH.LIST'
    F.BRANCH.UNAUTH.LIST = ''
    CALL OPF(FN.BRANCH.UNAUTH.LIST,F.BRANCH.UNAUTH.LIST)

    LOC.APP = "USER"
    LOC.FIELDS = "L.US.IDC.CODE":@VM:"L.US.IDC.BR"
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.APP,LOC.FIELDS,LOC.REF.POS)

    Y.IDC.POS = LOC.REF.POS<1,1>
    Y.BRANCH.POS = LOC.REF.POS<1,2>

RETURN
*-----------
PROCESS:
*-----------

    Y.FILE.NAME = R.ENQ<ENQ.FILE.NAME>

    Y.FILE.NAME = FIELD(Y.FILE.NAME,'$',1)

    Y.DATA = O.DATA

    Y.ID = FIELD(Y.DATA,"-",1)
    Y.INPUTTER = FIELD(Y.DATA,"-",2)

    CALL CACHE.READ(FN.USER, Y.INPUTTER, R.USER.VALUE, USE.ERR)    ;*R22 Auto Conversion - F.READ to CACHE.READ
    Y.IDC = R.USER.VALUE<EB.USE.LOCAL.REF,Y.IDC.POS,1>
    Y.BRANCH = R.USER.VALUE<EB.USE.LOCAL.REF,Y.BRANCH.POS,1>

    Y.CHECK.ID = Y.BRANCH:"-":Y.IDC:"-":Y.ID:"-":Y.FILE.NAME

    CALL F.READ(FN.BRANCH.UNAUTH.LIST,Y.CHECK.ID,R.BRANCH.UNAUTH.LIST,F.BRANCH.UNAUTH.LIST,BRA.ERR)

    Y.VERSION.NAME = FIELD(R.BRANCH.UNAUTH.LIST,"-",1)
    O.DATA = Y.VERSION.NAME

RETURN
*-----------------------------------------------------------------
END
