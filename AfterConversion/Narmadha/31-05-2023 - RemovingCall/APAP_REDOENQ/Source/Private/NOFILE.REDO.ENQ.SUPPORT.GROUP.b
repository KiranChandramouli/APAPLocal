$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.REDO.ENQ.SUPPORT.GROUP(Y.SUPP.ARR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is NOFILE ROUTINE to search the CLaims for each SUPPORT.GROUP user's
*
* This development is for ODR Reference ODR-2010-09-0170
* Input/Output:
*--------------
* IN  : Y.SUPP.ARR
* OUT : Y.SUPP.ARR
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
* Date              who              Reference            Description
* 16-JUL-2010       B Renugadevi     ODR-2010-09-0170    Initial Creation
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM and FM to @FM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CR.CONTACT.LOG
    $INSERT I_F.PW.PARTICIPANT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****

    FN.CR.CONTACT.LOG = 'F.CR.CONTACT.LOG'
    F.CR.CONTACT.LOG  = ''
    CALL OPF(FN.CR.CONTACT.LOG,F.CR.CONTACT.LOG)

    FN.PW.PARTICIPANT = 'F.PW.PARTICIPANT'
    F.PW.PARTICIPANT  = ''
    CALL OPF(FN.PW.PARTICIPANT,F.PW.PARTICIPANT)
    FN.CUSTOMER       = 'F.CUSTOMER'
    F.CUSTOMER        = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LREF.APPL                = 'CR.CONTACT.LOG'
    LREF.FIELDS              = 'L.CR.DUE.DATE':@VM:'L.CR.TYPE':@VM:'L.CR.SUPP.GRP':@VM:'L.CR.STATUS'
    LREF.POS                 = ''
    CALL MULTI.GET.LOC.REF(LREF.APPL, LREF.FIELDS, LREF.POS)
    L.CR.DUE.DATE            = LREF.POS<1,1>
    L.CR.TYPE                = LREF.POS<1,2>
    L.CR.SUPP.GRP            = LREF.POS<1,3>
    L.CR.STATUS              = LREF.POS<1,4>

RETURN
********
PROCESS:
********

    Y.CURR.USER  = OPERATOR
    LOCATE 'SUPPORT.GROUP' IN D.FIELDS<1> SETTING SUPP.POS THEN
        Y.SUPP.GRP = D.RANGE.AND.VALUE<SUPP.POS>
    END
    IF Y.SUPP.GRP NE '' THEN
        CALL F.READ(FN.PW.PARTICIPANT,Y.SUPP.GRP,R.PW.PARTICIPANT,F.PW.PARTICIPANT,PW.ERR)
        Y.SUPP.USER = R.PW.PARTICIPANT<PW.PART.USER>
        CHANGE @VM TO @FM IN Y.SUPP.USER
        LOCATE Y.CURR.USER IN Y.SUPP.USER SETTING USR.POS THEN
            SEL.CMD = "SELECT ":FN.CR.CONTACT.LOG:" WITH L.CR.USER EQ ":Y.CURR.USER:" AND L.CR.SUPP.GRP EQ ":Y.SUPP.GRP
        END
    END ELSE
        ENQ.ERROR = "SUPPORT GROUP is missing for this OPERATOR"
    END

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    LOOP
        REMOVE Y.CR.ID FROM SEL.LIST SETTING CR.POS
    WHILE Y.CR.ID:CR.POS
        CALL F.READ(FN.CR.CONTACT.LOG,Y.CR.ID,R.CR.CONTACT.LOG,F.CR.CONTACT.LOG,CR.ERR)
        IF R.CR.CONTACT.LOG THEN
            Y.TXN.ID         = Y.CR.ID
            Y.CUSTOMER       = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CLIENT>
            Y.CASE.ID1       = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTRACT.ID>
            Y.CASE.ID2       = Y.CASE.ID1[1,2]
            GOSUB FETCH.ID
            Y.DUE.DATE       = R.CR.CONTACT.LOG<CR.CONT.LOG.LOCAL.REF,L.CR.DUE.DATE>
            Y.TYPE           = R.CR.CONTACT.LOG<CR.CONT.LOG.LOCAL.REF,L.CR.TYPE>

            BEGIN CASE
                CASE Y.TYPE EQ "RECLAMACION"
                    Y.ENQ  = "ENQ REDO.ENQ.SUP.GRP.CLAIMS"
                CASE Y.TYPE EQ "SOLICITUD"
                    Y.ENQ  = "ENQ REDO.ENQ.SUP.GRP.REQUESTS"
                CASE Y.TYPE EQ "QUEJAS"
                    Y.ENQ  = "ENQ REDO.ENQ.SUP.GRP.COMPLAINTS"
            END CASE

            Y.SUPP.GRP       = R.CR.CONTACT.LOG<CR.CONT.LOG.LOCAL.REF,L.CR.SUPP.GRP>
            Y.STATUS         = R.CR.CONTACT.LOG<CR.CONT.LOG.LOCAL.REF,L.CR.STATUS>
            Y.CR.DESC        = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>
            Y.CR.DEPT        = R.CR.CONTACT.LOG<CR.CONT.LOG.COMPANY.CODE>
            CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            IF R.CUSTOMER THEN
                Y.CUSTOMER.NAME = R.CUSTOMER<EB.CUS.NAME.1>
            END
        END

        Y.SUPP.ARR<-1> = Y.DUE.DATE:'*':Y.TYPE:'*':Y.CUSTOMER.NAME:'*':Y.CASE.ID:'*':Y.CR.DESC:'*':Y.SUPP.GRP:'*':Y.CR.DEPT:'*':Y.TXN.ID:'*':Y.STATUS:'*':Y.ENQ
    REPEAT
RETURN

*********
FETCH.ID:
*********
    IF Y.CASE.ID2 EQ "57" THEN
        Y.ID1            = 0:Y.CASE.ID1[1,3]
        Y.ID2            = Y.CASE.ID1[4,4]
        Y.ID3            = Y.CASE.ID1[8,2]
        Y.ID4            = Y.CASE.ID1[10,5]
        Y.CASE.ID        = Y.ID1:'-':Y.ID2:'-':Y.ID3:'-':Y.ID4
    END
    IF Y.CASE.ID2 EQ "99" THEN
        Y.CASE.ID        = Y.CASE.ID1
    END

    IF Y.CASE.ID2 EQ "88" THEN
        Y.CASE.ID        = Y.CASE.ID1
    END
RETURN
*-------------------------------------------------------------------------------------------
END
