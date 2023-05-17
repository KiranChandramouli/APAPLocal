SUBROUTINE REDO.BUILD.NEW.ACTIVITIES(ENQ.DATA)
*---------------------------------------
*Description: This Build routine is for the enquiry REDO.AA.DETAILS.NEW.ACTIVITIES
* To display the list of activities based on user logged in.
*---------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.ENQUIRY
    $INSERT I_F.ENQUIRY.SELECT
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------
PROCESS:
*---------------------------------------
    Y.TREASURY = 'NO'
    GOSUB GET.USER.DEPT
    LOCATE 'ARRANGEMENT' IN ENQ.DATA<2,1> SETTING POS THEN
        Y.ARR.ID = ENQ.DATA<4,POS>
    END
    IF Y.TREASURY EQ 'NO' THEN
        ENQ.DATA<2,-1> = '@ID'
        ENQ.DATA<3,-1> = 'NE'
        ENQ.DATA<4,-1> = 'CHANGE.PRINCIPAL.OTHER CHANGE.PENALTINT.OTHER'
    END ELSE
        GOSUB GET.ACTIVITY
        ENQ.DATA<2,-1> = '@ID'
        ENQ.DATA<3,-1> = 'NE'
        ENQ.DATA<4,-1> = ACTIVITY.LIST
    END

RETURN
*---------------------------------------
GET.ACTIVITY:
*---------------------------------------
    ARR.INFO = ''
    ARR.INFO<1> = Y.ARR.ID
    R.ARRANGEMENT = ''
    Y.EFF.DATE = TODAY
    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO, Y.EFF.DATE, R.ARRANGEMENT, PROP.LIST)
    CLASS.LIST = ''
    CALL AA.GET.PROPERTY.CLASS(PROP.LIST, CLASS.LIST)         ;* Find their Property classes
    CLASS.LIST = RAISE(CLASS.LIST)
    PROP.LIST = RAISE(PROP.LIST)
    CLASS.CTR = ''
    ACTIVITY.LIST = ''

    LOOP
        REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
        CLASS.CTR +=1
    WHILE Y.CLASS:CLASS.POS
        IF Y.CLASS EQ "INTEREST" THEN
            ACTIVITY.LIST<-1> = "LENDING-CHANGE-":PROP.LIST<CLASS.CTR>      ;*Get the interest property
        END
    REPEAT

    CHANGE @FM TO ' ' IN ACTIVITY.LIST

RETURN
*---------------------------------------
GET.USER.DEPT:
*---------------------------------------

    LOC.REF.APPLICATION="USER"
    LOC.REF.FIELDS='L.US.IDC.CODE'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.US.IDC.CODE = LOC.REF.POS<1,1>

    LOCATE '217' IN R.USER<EB.USE.LOCAL.REF,POS.L.US.IDC.CODE,1> SETTING POS2 THEN
        Y.TREASURY = 'YES'
    END
RETURN
END
