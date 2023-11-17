* @ValidationCode : MjotOTI1MjM3OTU6Q3AxMjUyOjE2ODEyNzY1NTUwNzY6SVRTUzotMTotMTo5Mjk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 929
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AC.PODER(Y.ENQ.OUT)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AC.PODER
*--------------------------------------------------------------------------------------------------------
*Description       :
*
*Linked With       : NOFILE ENQUIRY
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : ACCOUNT
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date                 Who                  Reference                 Description
*  ------               -----               -------------              -------------
*  21-10-2013          S.SUDHARSANAN           699242                   Initial Description
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY
    $INSERT I_F.COUNTRY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.REDO.RELATION.CODE.PARAM

    GOSUB INIT
    GOSUB PROCESS
    GOSUB PGM.END
RETURN

INIT:
********
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    FN.COUNTRY = 'F.COUNTRY'
    F.COUNTRY = ''
    CALL OPF(FN.COUNTRY,F.COUNTRY)

    FN.REL.COD.PARAM = 'F.REDO.RELATION.CODE.PARAM'
    PARAM.ID = "SYSTEM"

    CALL CACHE.READ(FN.REL.COD.PARAM,PARAM.ID,R.REL.COD.PARAM,REL.ERR)
    Y.JOINT.HOLDER.FROM = R.REL.COD.PARAM<RECO.JOINT.HOLDER.FROM>
    Y.JOINT.HOLDER.TO = R.REL.COD.PARAM<RECO.JOINT.HOLDER.TO>
    Y.POA.FROM = R.REL.COD.PARAM<RECO.POA.FROM>
    Y.POA.TO = R.REL.COD.PARAM<RECO.POA.TO>

    APPL = 'CUSTOMER':@FM:'ACCOUNT'
    FIELD.NAMES = 'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.RES.SECTOR':@VM:'L.CU.URB.ENS.RE':@FM:'L.AC.STATUS1'
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL,FIELD.NAMES,FIELD.POS)
    L.CU.TIPO.POS = FIELD.POS<1,1>
    L.CU.CIDENT.POS = FIELD.POS<1,2>
    L.CU.RES.SECTOR.POS = FIELD.POS<1,3>
    L.CU.URB.ENS.RE.POS = FIELD.POS<1,4>
    L.AC.STATUS1.POS    = FIELD.POS<2,1>
    POA.FLAG = ''
    STATUS.FLAG = ''
RETURN
*--------------------------------------------------------------------------------------------------
PROCESS:
*********

    LOCATE "ACCOUNT.ID" IN D.FIELDS<1> SETTING ACCT.POS THEN
        Y.ID = D.RANGE.AND.VALUE<ACCT.POS>
        CALL F.READ(FN.ACCOUNT,Y.ID,R.ACC,F.ACCOUNT,ACC.ERR)
        IF NOT(R.ACC) THEN
            CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ID,R.ALT.AC,F.ALTERNATE.ACCOUNT,ALT.AC.ERR)
            IF R.ALT.AC THEN
                Y.ID = R.ALT.AC<AAC.GLOBUS.ACCT.NUMBER>
                CALL F.READ(FN.ACCOUNT,Y.ID,R.ACC,F.ACCOUNT,ACC.ERR)
                GOSUB VAULE.INPUT.AC
            END
        END ELSE
            GOSUB VAULE.INPUT.AC
        END
    END

RETURN
*****************
VAULE.INPUT.AC:
*****************
    CUS.ID = R.ACC<AC.CUSTOMER>
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    VAR.CUS.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.POS>

    Y.JOINT.HOLDER = R.ACC<AC.JOINT.HOLDER>
    Y.RELATION.CODE = R.ACC<AC.RELATION.CODE>

    CHANGE @VM TO @FM IN Y.RELATION.CODE
    CHANGE @VM TO @FM IN Y.JOINT.HOLDER
    Y.REL.CNT = DCOUNT(Y.RELATION.CODE,@FM)

    GOSUB CHECK.POA
    GOSUB CHECK.ACCT.STATUS

    IF VAR.CUS.TYPE EQ 'PERSONA FISICA' AND POA.FLAG EQ '1' AND STATUS.FLAG EQ '1' THEN
*THIS PART IS USED TO CHECKS THE VALUES OF PRIMARY HOLDER - S
        GOSUB GET.CUST.DET

        Y.HOLDER.NAME<1,-1> = Y.CU.NAME
        Y.HOLDER.NATION<1,-1> = Y.NATIONALITY
        Y.HOLDER.MARITAL<1,-1> = Y.MARITAL.STATUS
        Y.HOLDER.ID<1,-1> = Y.ID.NUM
        Y.HOLDER.ADDRESS<1,-1> = Y.CU.ADDRESS

*THIS PART IS USED TO CHECKS THE VALUES OF PRIMARY HOLDER - E

        GOSUB CHECK.RELATION
        Y.DATE = TODAY
        GOSUB JAVA.PART
        Y.ENQ.OUT<-1> = Y.ID :"*":Y.HOLDER.NAME:"*":Y.HOLDER.NATION:"*":Y.HOLDER.MARITAL:"*":Y.HOLDER.ID:"*":Y.HOLDER.ADDRESS:"*":Y.POA.NAME:"*":Y.POA.NATION:"*":Y.POA.MARITAL:"*":Y.POA.ID:"*":Y.POA.ADDRESS:"*":Y.DATE:"*":Y.OUTPUT
    END ELSE

        GOSUB PGM.END

    END
RETURN

*----------
CHECK.POA:
*----------
    CNT = 1
    LOOP
    WHILE CNT LE Y.REL.CNT
        Y.REL.CODE.VALUE = Y.RELATION.CODE<CNT>
        IF Y.REL.CODE.VALUE GE Y.POA.FROM AND Y.REL.CODE.VALUE LE Y.POA.TO THEN
            POA.FLAG = '1'
            CNT = Y.REL.CNT+1
        END
        CNT += 1
    REPEAT


RETURN
*---------------
CHECK.ACCT.STATUS:
*------------------
    IF R.ACC<AC.LOCAL.REF,L.AC.STATUS1.POS>  EQ 'ACTIVE' THEN
        STATUS.FLAG = 1
    END
RETURN
*-----------------
CHECK.RELATION:
*---------------
    Y.REL.CNT = DCOUNT(Y.RELATION.CODE,@FM)

    CNT = 1
    LOOP
    WHILE CNT LE Y.REL.CNT

        Y.REL.CODE.VALUE = Y.RELATION.CODE<CNT>

        BEGIN CASE

            CASE Y.REL.CODE.VALUE GE Y.JOINT.HOLDER.FROM AND Y.REL.CODE.VALUE LE Y.JOINT.HOLDER.TO
                CUS.ID = Y.JOINT.HOLDER<CNT>
                CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
                VAR.CUS.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.POS>
                IF VAR.CUS.TYPE EQ 'PERSONA FISICA' THEN
                    GOSUB GET.CUST.DET
                    Y.HOLDER.NAME<1,-1> = Y.CU.NAME
                    Y.HOLDER.NATION<1,-1> = Y.NATIONALITY
                    Y.HOLDER.MARITAL<1,-1> = Y.MARITAL.STATUS
                    Y.HOLDER.ID<1,-1> = Y.ID.NUM
                    Y.HOLDER.ADDRESS<1,-1> = Y.CU.ADDRESS
                END

            CASE Y.REL.CODE.VALUE GE Y.POA.FROM AND Y.REL.CODE.VALUE LE Y.POA.TO
                CUS.ID = Y.JOINT.HOLDER<CNT>
                CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
                VAR.CUS.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.POS>
                IF VAR.CUS.TYPE EQ 'PERSONA FISICA' THEN
                    GOSUB GET.CUST.DET
                    Y.POA.NAME<1,-1> = Y.CU.NAME
                    Y.POA.NATION<1,-1> = Y.NATIONALITY
                    Y.POA.MARITAL<1,-1> = Y.MARITAL.STATUS
                    Y.POA.ID<1,-1> = Y.ID.NUM
                    Y.POA.ADDRESS<1,-1> = Y.CU.ADDRESS
                END
        END CASE

        CNT += 1
    REPEAT

RETURN
********************
GET.CUST.DET:
********************

*2ND FIELD ACCT HOLDER NAME

    Y.CU.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
* 3RD FIELD
    Y.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    CALL CACHE.READ(FN.COUNTRY, Y.NATION, R.COUNTRY, CON.ERR) ;*AUTO R22 CODE CONVERSION
    Y.NATIONALITY = R.COUNTRY<EB.COU.COUNTRY.NAME>
*4TH FIELD
    Y.MARITAL.STATUS = R.CUSTOMER<EB.CUS.MARITAL.STATUS>

*5TH FIELD CUS ID NUM

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE '' THEN
        Y.ID.NUM = "CED.":R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    END ELSE
        Y.ID.NUM = "PASP.":R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END

*6TH FIELD

    Y.STREET = R.CUSTOMER<EB.CUS.STREET>
    Y.ADDRESS = R.CUSTOMER<EB.CUS.ADDRESS>
    Y.SECTOR = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RES.SECTOR.POS>
    Y.URB.ENS = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.URB.ENS.RE.POS>
    Y.COUNTRY = R.CUSTOMER<EB.CUS.COUNTRY>
    Y.RESIDENCE = R.CUSTOMER<EB.CUS.RESIDENCE>
    CALL CACHE.READ(FN.COUNTRY, Y.RESIDENCE, R.COUNTRY, CON.ERR) ;*AUTO R22 CODE CONVERSION
    Y.PAIS = R.COUNTRY<EB.COU.COUNTRY.NAME>
    Y.CU.ADDRESS = ''
    IF Y.STREET THEN
        Y.CU.ADDRESS<-1> = Y.STREET
    END

    IF Y.ADDRESS THEN
        Y.CU.ADDRESS<-1> = Y.ADDRESS
    END
    IF Y.SECTOR THEN
        Y.CU.ADDRESS<-1> = Y.SECTOR
    END
    IF Y.URB.ENS THEN
        Y.CU.ADDRESS<-1> = Y.URB.ENS
    END

    IF Y.COUNTRY THEN
        Y.CU.ADDRESS<-1> = Y.COUNTRY
    END

    IF Y.PAIS THEN
        Y.CU.ADDRESS<-1> = Y.PAIS

    END

    CHANGE @FM TO "," IN Y.CU.ADDRESS

RETURN
*--------------------------------------------------------------------------------------------------------------
JAVA.PART:
*--------------------------------------------------------------------------------------------------------------
    Y.JAVA.ID = Y.ID
    Y.JAVA.HOLDER.NAME = Y.HOLDER.NAME
    Y.JAVA.HOLDER.NATION = Y.HOLDER.NATION
    Y.JAVA.HOLDER.MARITAL = Y.HOLDER.MARITAL
    Y.JAVA.HOLDER.ID = Y.HOLDER.ID
    Y.JAVA.HOLDER.ADDRESS = Y.HOLDER.ADDRESS
    Y.JAVA.POA.NAME = Y.POA.NAME
    Y.JAVA.POA.NATION = Y.POA.NATION
    Y.JAVA.POA.MARITAL = Y.POA.MARITAL
    Y.JAVA.POA.ID = Y.POA.ID
    Y.JAVA.POA.ADDRESS = Y.POA.ADDRESS


    CHANGE @VM TO "##" IN Y.JAVA.HOLDER.NAME
    CHANGE @VM TO "##" IN Y.JAVA.HOLDER.NATION
    CHANGE @VM TO "##" IN Y.JAVA.HOLDER.MARITAL
    CHANGE @VM TO "##" IN Y.JAVA.HOLDER.ID
    CHANGE @VM TO "##" IN Y.JAVA.HOLDER.ADDRESS
    CHANGE @VM TO "##" IN Y.JAVA.POA.NAME
    CHANGE @VM TO "##" IN Y.JAVA.POA.NATION
    CHANGE @VM TO "##" IN Y.JAVA.POA.MARITAL
    CHANGE @VM TO "##" IN Y.JAVA.POA.ID
    CHANGE @VM TO "##" IN Y.JAVA.POA.ADDRESS

    Y.OUTPUT = "FVAL:FD1=":Y.JAVA.ID :"^^FD2=":Y.JAVA.HOLDER.NAME:"^^FD3=":Y.JAVA.HOLDER.NATION:"^^FD4=":Y.JAVA.HOLDER.MARITAL:"^^FD5=":Y.JAVA.HOLDER.ID:"^^FD6=":Y.JAVA.HOLDER.ADDRESS:"^^FD7=":Y.JAVA.POA.NAME:"^^FD8=":Y.JAVA.POA.NATION:"^^FD9=":Y.JAVA.POA.MARITAL:"^^FD10=":Y.JAVA.POA.ID:"^^FD11=":Y.JAVA.POA.ADDRESS

RETURN
*---------------------------------------------------------------------------------------------------------------
PGM.END:
*---------------------------------------------------
END
