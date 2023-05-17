*-----------------------------------------------------------------------------
* <Rating>-417</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.ENQ.CAMP.REP.STAT(DATA.RECORD)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached to the nofile enquiry to retrieve the Campaign statistics
*-------------------------------------------------------------------------
* HISTORY:
*---------
* Date who Reference Description

* 24-AUG-2011 SHANKAR RAJU ODR-2011-07-0162 Initial Creation
* 24-MAR-2012 Prabhu PACS00188191 REDO.H.CAMPAIGN.DETAILS commented
*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CR.CONTACT.LOG
$INSERT I_F.CR.OPPORTUNITY
$INSERT I_F.CR.CAMPAIGN.GENERATOR
$INSERT I_F.CR.OPPORTUNITY.GENERATOR
$INSERT I_F.CUSTOMER

GOSUB OPEN.FILES
GOSUB FORM.SEL.STMT
GOSUB PROCESS
GOSUB APEND.HEADER

RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*----------

FN.CUSTOMER = 'F.CUSTOMER'
F.CUSTOMER = ''
CALL OPF(FN.CUSTOMER, F.CUSTOMER)

FN.CUSTOMER.PROSPECT = 'F.CUSTOMER.PROSPECT'
F.CUSTOMER.PROSPECT = ''
CALL OPF(FN.CUSTOMER.PROSPECT, F.CUSTOMER.PROSPECT)

FN.CR.OPPORTUNITY = 'F.CR.OPPORTUNITY'
F.CR.OPPORTUNITY = ''
CALL OPF(FN.CR.OPPORTUNITY, F.CR.OPPORTUNITY)

FN.CR.CAMPAIGN.GENERATOR = 'F.CR.CAMPAIGN.GENERATOR'
F.CR.CAMPAIGN.GENERATOR = ''
CALL OPF(FN.CR.CAMPAIGN.GENERATOR, F.CR.CAMPAIGN.GENERATOR)

FN.CR.OPPORTUNITY.GENERATOR = 'F.CR.OPPORTUNITY.GENERATOR'
F.CR.OPPORTUNITY.GENERATOR = ''
CALL OPF(FN.CR.OPPORTUNITY.GENERATOR,F.CR.OPPORTUNITY.GENERATOR)

FN.CR.CONTACT.LOG = 'F.CR.CONTACT.LOG'
F.CR.CONTACT.LOG = ''
CALL OPF(FN.CR.CONTACT.LOG, F.CR.CONTACT.LOG)

* FN.REDO.H.CAMPAIGN.DETAILS = 'F.REDO.H.CAMPAIGN.DETAILS'
* F.REDO.H.CAMPAIGN.DETAILS = ''
* CALL OPF(FN.REDO.H.CAMPAIGN.DETAILS,F.REDO.H.CAMPAIGN.DETAILS)

Y.LREF.APP = 'CUSTOMER'
Y.LREF.FIELD = 'L.CU.SEGMENTO'
L.CU.SEGMENTO.POS = ''
CALL GET.LOC.REF(Y.LREF.APP,Y.LREF.FIELD,L.CU.SEGMENTO.POS)


GOSUB CLEAR.VALUES

RETURN
*-----------------------------------------------------------------------------
FORM.SEL.STMT:
*-------------

SEL.CMD = "SELECT ":FN.CR.CONTACT.LOG:" WITH CONTACT.TYPE EQ 'CAMPAIGNS' BY CONTACT.DESC BY @ID"
CALL EB.READLIST(SEL.CMD,CR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-------
FLAG.FIRST.READ = 0

CNT = 1
LOOP.CNT = NO.OF.REC.ARR

LOOP
WHILE CNT LE LOOP.CNT
FLAG.NEXT.LOOP = 0
Y.READ.FURTHER = 0
Y.CR.ID = CR.ID.LST<CNT>
GOSUB ASSIGN.VALUES
GOSUB READ.EACH.DESCR
GOSUB CHECK.FORM.ARRAY
CNT++
REPEAT

RETURN
*-----------------------------------------------------------------------------
ASSIGN.VALUES:
*-------------

READ.DESC.AGAIN = 0

GOSUB READ.CR.CUS.ID
GOSUB CAMP.DETAILS
IF READ.DESC.AGAIN NE 1 THEN
FLAG.READ.DESC = ''
END

IF FLAG.NEXT.LOOP NE 1 THEN
GOSUB READ.CUST.FLDS
END

RETURN
*-----------------------------------------------------------------------------
READ.CR.CUS.ID:
*--------------

OLD.CR.LOG.DESC.1 = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>
OLD.CR.LOG.DESC = OLD.CR.LOG.DESC.1
R.CR.CONTACT.LOG = ''

CALL F.READ(FN.CR.CONTACT.LOG,Y.CR.ID,R.CR.CONTACT.LOG,F.CR.CONTACT.LOG,ERR.CL)
Y.CUST.ID = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CLIENT>
NEW.CR.LOG.DESC.1 = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>
NEW.CR.LOG.DESC = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>

RETURN
*-----------------------------------------------------------------------------
READ.CR.CUS:
*-----------

OLD.CR.LOG.DESC = OLD.CR.LOG.DESC.1

NEW.CR.LOG.DESC = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>
Y.CR.LOG.START.DATE = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DATE>

R.CUSTOMER = ''

CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUS)

RETURN
*-----------------------------------------------------------------------------
CHECK.FORM.ARRAY:
*----------------

IF ((OLD.CR.LOG.DESC NE '') OR (Y.CR.ID EQ CR.ID.LST<NO.OF.REC.ARR>)) AND ((OLD.CR.LOG.DESC NE NEW.CR.LOG.DESC) OR (Y.CR.ID EQ CR.ID.LST<NO.OF.REC.ARR>)) THEN
GOSUB CALC.PERCENT
GOSUB FORM.ARRAY
GOSUB CLEAR.VALUES
FLAG.READ.DESC = 1
OLD.CR.LOG.DESC = ''
END

RETURN
*-----------------------------------------------------------------------------
CAMP.DETAILS:
*------------

BEGIN CASE
CASE NEW.CR.LOG.DESC.1 EQ 'Campaign Savings Account'
Y.OPP.DEF.IDS = "REDO.APAP.SAV"

CASE NEW.CR.LOG.DESC.1 EQ 'Outbound Campaign Loans (AA)'
Y.OPP.DEF.IDS = "REDO.APAP.AA"

CASE NEW.CR.LOG.DESC.1 EQ 'Inbound Campaign ARC-IB user accounts'
Y.OPP.DEF.IDS = "REDO.APAP.ARC"

CASE NEW.CR.LOG.DESC.1 EQ 'Outbound Campaign for Credit Card'
Y.OPP.DEF.IDS = "REDO.APAP.CC"
END CASE

SEL.OPP.CMD = "SELECT ":FN.CR.OPPORTUNITY:" WITH CUSTOMER EQ ":Y.CUST.ID:" AND WITH OPPOR.DEF.ID EQ ":Y.OPP.DEF.IDS:" AND WITH END.DATE GE ":TODAY
CALL EB.READLIST(SEL.OPP.CMD,Y.OPP.LIST,'',NO.OF.OPP,ERR.OPP)

Y.OP.GEN.ID = Y.OPP.LIST<NO.OF.OPP>

IF Y.OP.GEN.ID EQ '' THEN
IF Y.OPP.DEF.IDS EQ "REDO.APAP.CC" THEN
Y.OP.GEN.ID = Y.OPP.DEF.IDS
GOSUB READ.CR.CUS
IF (FLAG.FIRST.READ NE 1) OR (FLAG.READ.DESC EQ 1) THEN
FLAG.FIRST.READ = 1
END
GOSUB GO.READ.FURTHER
IF Y.CR.ID EQ CR.ID.LST<NO.OF.REC.ARR> ELSE
GOSUB CHECK.FORM.ARRAY
END
END ELSE
IF Y.OPP.DEF.IDS EQ "REDO.APAP.AA" THEN
Y.OP.GEN.ID = Y.OPP.DEF.IDS
GOSUB READ.CR.CUS
IF (FLAG.FIRST.READ NE 1) OR (FLAG.READ.DESC EQ 1) THEN
FLAG.FIRST.READ = 1
END
GOSUB GO.READ.FURTHER
IF Y.CR.ID EQ CR.ID.LST<NO.OF.REC.ARR> ELSE
GOSUB CHECK.FORM.ARRAY
END
END ELSE
FLAG.NEXT.LOOP = 1
END
END
END ELSE
CALL F.READ(FN.CR.OPPORTUNITY,Y.OP.GEN.ID,R.CR.OPPORTUNITY,F.CR.OPPORTUNITY,ERR.OPP)
Y.OP.GEN.ID = R.CR.OPPORTUNITY<CR.OP.OP.GENR.ID>
GOSUB READ.CR.CUS
IF (FLAG.FIRST.READ NE 1) OR (FLAG.READ.DESC EQ 1) THEN
FLAG.FIRST.READ = 1
END
GOSUB GO.READ.FURTHER
IF Y.CR.ID EQ CR.ID.LST<NO.OF.REC.ARR> ELSE
GOSUB CHECK.FORM.ARRAY
END
END

RETURN
*-----------------------------------------------------------------------------
GO.READ.FURTHER:
*---------------
IF Y.OP.GEN.ID EQ '' THEN
Y.OP.GEN.ID = R.CR.OPPORTUNITY<CR.OP.CAMPAIGN.ID>
IF FLAG.READ.DESC EQ 1 THEN
READ.DESC.AGAIN = 1
END
END

CALL F.READ(FN.CR.CAMPAIGN.GENERATOR,Y.OP.GEN.ID,R.CR.CAMPAIGN.GENERATOR,F.CR.CAMPAIGN.GENERATOR,ERR.CAMP.GEN)
IF R.CR.CAMPAIGN.GENERATOR THEN
Y.DESCRIPTION = R.CR.CAMPAIGN.GENERATOR<CR.CG.DESCRIPTION>
Y.START.DATE = R.CR.CAMPAIGN.GENERATOR<CR.CG.CAMP.START.DATE>
Y.END.DATE = R.CR.CAMPAIGN.GENERATOR<CR.CG.CAMP.END.DATE>
Y.START.DATE.1 = Y.START.DATE[7,2]:"/":Y.START.DATE[5,2]:"/":Y.START.DATE[1,4]
Y.END.DATE.1 = Y.END.DATE[7,2]:"/":Y.END.DATE[5,2]:"/":Y.END.DATE[1,4]
GOSUB HEADER.DETAILS

IF (Y.CR.LOG.START.DATE GE Y.START.DATE) AND (Y.CR.LOG.START.DATE LE Y.END.DATE) ELSE
FLAG.NEXT.LOOP = 1
END

IF Y.END.DATE LT TODAY THEN
FLAG.NEXT.LOOP = 1
IF FLAG.READ.DESC EQ 1 THEN
READ.DESC.AGAIN = 1
END
END
END ELSE
CALL F.READ(FN.CR.OPPORTUNITY.GENERATOR,Y.OP.GEN.ID,R.CR.OPPORTUNITY.GENERATOR,F.CR.OPPORTUNITY.GENERATOR,ERR.OPP.GEN)
IF R.CR.OPPORTUNITY.GENERATOR THEN
Y.DESCRIPTION = R.CR.OPPORTUNITY.GENERATOR<CR.OG.DESCRIPTION>
Y.START.DATE = R.CR.OPPORTUNITY.GENERATOR<CR.OG.START.DATE>
Y.DURATION = R.CR.OPPORTUNITY.GENERATOR<CR.OG.DURATION>
IF Y.START.DATE NE '' AND Y.DURATION NE '' THEN
CALL CALENDAR.DAY(Y.START.DATE,'+',Y.DURATION)
END
Y.END.DATE = Y.DURATION
IF (Y.CR.LOG.START.DATE GE Y.START.DATE) AND (Y.CR.LOG.START.DATE LE Y.END.DATE) ELSE
FLAG.NEXT.LOOP = 1
END
IF Y.END.DATE LT TODAY THEN
FLAG.NEXT.LOOP = 1
IF FLAG.READ.DESC EQ 1 THEN
READ.DESC.AGAIN = 1
END
END
Y.START.DATE.1 = Y.START.DATE[7,2]:"/":Y.START.DATE[5,2]:"/":Y.START.DATE[1,4]
Y.END.DATE.1 = Y.END.DATE[7,2]:"/":Y.END.DATE[5,2]:"/":Y.END.DATE[1,4]
GOSUB HEADER.DETAILS

END ELSE
FLAG.NEXT.LOOP = 1
IF FLAG.READ.DESC EQ 1 THEN
READ.DESC.AGAIN = 1
END
END
END

RETURN
*-----------------------------------------------------------------------------
HEADER.DETAILS:
*--------------

IF Y.FROM.DATE EQ '' OR Y.FROM.DATE GT Y.START.DATE THEN
Y.FROM.DATE = Y.START.DATE
END

IF Y.TO.DATE EQ '' OR Y.TO.DATE LT Y.END.DATE THEN
Y.TO.DATE = Y.END.DATE
END

Y.FROM.DATE.1 = Y.FROM.DATE[7,2]:"/":Y.FROM.DATE[5,2]:"/":Y.FROM.DATE[1,4]
Y.TO.DATE.1 = Y.TO.DATE[7,2]:"/":Y.TO.DATE[5,2]:"/":Y.TO.DATE[1,4]

Y.COMPANY.CODE = R.CR.CONTACT.LOG<CR.CONT.LOG.COMPANY.CODE>
Y.CHANNEL = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CHANNEL>
Y.CO.CODE = R.CR.CONTACT.LOG<CR.CONT.LOG.CO.CODE>
Y.DEPT.ACCT.OFF = R.CR.CONTACT.LOG<CR.CONT.LOG.DEPT.CODE>

RETURN
*-----------------------------------------------------------------------------
APEND.HEADER:
*------------
DATA.RECORD<1> := "*":Y.FROM.DATE.1:"*":Y.TO.DATE.1:"*":Y.COMPANY.CODE:"*":Y.CHANNEL:"*":Y.CO.CODE:"*":Y.DEPT.ACCT.OFF

RETURN
*-----------------------------------------------------------------------------
ASSIGN.VALUES.STAUS.CUST:
*------------------------

Y.CONTACT.STATUS = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.STATUS>

* CONTACTED
IF (Y.CONTACT.STATUS EQ 'ACEPTA') OR (Y.CONTACT.STATUS EQ 'PROCESO.PRESTAMO') OR (Y.CONTACT.STATUS EQ 'PROCESO.TC') OR (Y.CONTACT.STATUS EQ 'RECHAZA.FDC') OR (Y.CONTACT.STATUS EQ 'FIRMADO') OR (Y.CONTACT.STATUS EQ 'CONFIRMADO') THEN
Y.TOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.CLIENTS += 1
Y.NO.CLIENTS.CONT += 1
Y.ACCEPT.OFR += 1
GOSUB COUNT.PROS.SEGMENT
END

IF Y.CONTACT.STATUS EQ 'REFORMULA.OFERTA' THEN
Y.TOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.CLIENTS += 1
Y.NO.CLIENTS.CONT += 1
Y.REF.OFR += 1
GOSUB COUNT.PROS.SEGMENT
END

IF Y.CONTACT.STATUS EQ 'REPROG.CONTACTO' THEN
Y.TOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.CLIENTS += 1
Y.NO.CLIENTS.CONT += 1
Y.RESCH.CONT += 1
GOSUB COUNT.PROS.SEGMENT
END

IF Y.CONTACT.STATUS EQ 'RECHAZA.OFERTA' THEN
Y.TOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.CLIENTS += 1
Y.NO.CLIENTS.CONT += 1
Y.REJ.OFR += 1
GOSUB COUNT.PROS.SEGMENT
END
* CONTACTED

* ATTEMPTED
IF Y.CONTACT.STATUS EQ 'NO.COMPLETADA' THEN
Y.TOT.NOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.CLIENTS += 1
Y.NO.ANS += 1
END

IF Y.CONTACT.STATUS EQ 'OCUPADO' THEN
Y.TOT.NOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.CLIENTS += 1
Y.BUSY.PH.NO += 1
END

IF Y.CONTACT.STATUS EQ 'NUMERO.EQUIVOCADO' THEN
Y.TOT.NOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.CLIENTS += 1
Y.INC.PH.NO += 1
END

IF Y.CONTACT.STATUS EQ 'DESCONECTADO' THEN
Y.TOT.NOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.CLIENTS += 1
Y.DISC.PH.NO += 1
END
* ATTEMPTED

* NOT COMMUNICATED
IF Y.CONTACT.STATUS EQ 'NO.COMMUNICADO' THEN
Y.NO.CLIENTS += 1
END
* NOT COMMUNICATED

RETURN
*-----------------------------------------------------------------------------
ASSIGN.VALUES.STAUS.PROS:
*------------------------

Y.CONTACT.STATUS = R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.STATUS>

* CONTACTED
IF (Y.CONTACT.STATUS EQ 'ACEPTA') OR (Y.CONTACT.STATUS EQ 'PROCESO.PRESTAMO') OR (Y.CONTACT.STATUS EQ 'PROCESO.TC') OR (Y.CONTACT.STATUS EQ 'RECHAZA.FDC') OR (Y.CONTACT.STATUS EQ 'FIRMADO') OR (Y.CONTACT.STATUS EQ 'CONFIRMADO') THEN
Y.TOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.PROS += 1
Y.NO.PROS.CONT += 1
Y.ACCEPT.OFR += 1
GOSUB COUNT.CUS.SEGMENT
END

IF Y.CONTACT.STATUS EQ 'REFORMULA.OFERTA' THEN
Y.TOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.PROS += 1
Y.NO.PROS.CONT += 1
Y.REF.OFR += 1
GOSUB COUNT.CUS.SEGMENT
END

IF Y.CONTACT.STATUS EQ 'REPROG.CONTACTO' THEN
Y.TOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.PROS += 1
Y.NO.PROS.CONT += 1
Y.RESCH.CONT += 1
GOSUB COUNT.CUS.SEGMENT
END

IF Y.CONTACT.STATUS EQ 'RECHAZA.OFERTA' THEN
Y.TOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.PROS += 1
Y.NO.PROS.CONT += 1
Y.REJ.OFR += 1
GOSUB COUNT.CUS.SEGMENT
END
* CONTACTED

* ATTEMPTED
IF Y.CONTACT.STATUS EQ 'NO.COMPLETADA' THEN
Y.TOT.NOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.PROS += 1
Y.NO.ANS += 1
END

IF Y.CONTACT.STATUS EQ 'OCUPADO' THEN
Y.TOT.NOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.PROS += 1
Y.BUSY.PH.NO += 1
END

IF Y.CONTACT.STATUS EQ 'NUMERO.EQUIVOCADO' THEN
Y.TOT.NOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.PROS += 1
Y.INC.PH.NO += 1
END

IF Y.CONTACT.STATUS EQ 'DESCONECTADO' THEN
Y.TOT.NOT.CONT += 1
Y.CUS.CONT += 1
Y.NO.PROS += 1
Y.DISC.PH.NO += 1
END
* ATTEMPTED

* NOT COMMUNICATED
IF Y.CONTACT.STATUS EQ 'NO.COMMUNICADO' THEN
Y.NO.PROS += 1
END
* NOT COMMUNICATED

RETURN
*-----------------------------------------------------------------------------
READ.EACH.DESCR:
*---------------
IF Y.DESCRIPTION.FIN EQ '' OR Y.START.DATE.FIN EQ '' OR Y.END.DATE.FIN EQ '' THEN

Y.DESCRIPTION.FIN = Y.DESCRIPTION
Y.START.DATE.FIN = Y.START.DATE.1
Y.END.DATE.FIN = Y.END.DATE.1
END
RETURN
*-----------------------------------------------------------------------------
READ.CUST.FLDS:
*--------------

GOSUB READ.EACH.DESCR

Y.TOT.CUS += 1

Y.CUS.SEGMENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>

IF R.CUSTOMER<EB.CUS.CUSTOMER.TYPE> EQ 'PROSPECT' THEN
GOSUB ASSIGN.VALUES.STAUS.PROS
END ELSE
GOSUB ASSIGN.VALUES.STAUS.CUST
END

RETURN
*-----------------------------------------------------------------------------
COUNT.CUS.SEGMENT:
*-----------------
IF Y.CUS.SEGMENT EQ 'PLATINUM' THEN
Y.PRO.SEG.PLATINUM += 1
END
IF Y.CUS.SEGMENT EQ 'GOLD' THEN
Y.PRO.SEG.ORO += 1
END
IF Y.CUS.SEGMENT EQ 'SILVER' THEN
Y.PRO.SEG.PLATA += 1
END
IF Y.CUS.SEGMENT EQ 'BRONZE' THEN
Y.PRO.SEG.BRONZE += 1
END
IF Y.CUS.SEGMENT EQ 'COPPER' THEN
Y.PRO.SEG.COBRE += 1
END
IF Y.CUS.SEGMENT EQ '' THEN
Y.NO.SEGMENT += 1
END
RETURN
*-----------------------------------------------------------------------------
COUNT.PROS.SEGMENT:
*------------------
IF Y.CUS.SEGMENT EQ 'PLATINUM' THEN
Y.CUS.SEG.PLATINUM += 1
END
IF Y.CUS.SEGMENT EQ 'GOLD' THEN
Y.CUS.SEG.ORO += 1
END
IF Y.CUS.SEGMENT EQ 'SILVER' THEN
Y.CUS.SEG.PLATA += 1
END
IF Y.CUS.SEGMENT EQ 'BRONZE' THEN
Y.CUS.SEG.BRONZE += 1
END
IF Y.CUS.SEGMENT EQ 'COPPER' THEN
Y.CUS.SEG.COBRE += 1
END
RETURN
*-----------------------------------------------------------------------------
CALC.PERCENT:
*------------
Y.CUS.NOT.CONT = Y.TOT.CUS - Y.CUS.CONT

IF Y.TOT.CUS NE 0 THEN
Y.CUS.PERC = "100%"
END ELSE
Y.CUS.PERC = "0%"
END

IF Y.CUS.CONT NE 0 AND Y.TOT.CUS NE 0 THEN
Y.CUS.CON.PER = DROUND(((Y.CUS.CONT/Y.TOT.CUS)*100),0):"%"
END ELSE
Y.CUS.CON.PER = "0%"
END

IF Y.CUS.NOT.CONT NE 0 AND Y.TOT.CUS NE 0 THEN
Y.CUS.NOT.CON.PER = DROUND(((Y.CUS.NOT.CONT/Y.TOT.CUS)*100),0):"%"
END ELSE
Y.CUS.NOT.CON.PER = "0%"
END

IF Y.CUS.CONT NE 0 AND Y.NO.CLIENTS NE 0 THEN
Y.CLIENTS.PERC = DROUND(((Y.NO.CLIENTS/Y.CUS.CONT)*100),0):"%"
END ELSE
Y.CLIENTS.PERC = "0%"
END

IF Y.NO.CLIENTS.CONT NE 0 AND Y.NO.CLIENTS NE 0 THEN
Y.CLIENTS.CONT.PERC = DROUND(((Y.NO.CLIENTS.CONT/Y.NO.CLIENTS)*100),0):"%"
END ELSE
Y.CLIENTS.CONT.PERC = "0%"
END

IF Y.NO.PROS NE 0 AND Y.CUS.CONT NE 0 THEN
Y.PROS.PERC = DROUND(((Y.NO.PROS/Y.CUS.CONT)*100),0):"%"
END ELSE
Y.PROS.PERC = "0%"
END

IF Y.NO.PROS.CONT NE 0 AND Y.NO.PROS NE 0 THEN
Y.PROS.CONT.PERC = DROUND(((Y.NO.PROS.CONT/Y.NO.PROS)*100),0):"%"
END ELSE
Y.PROS.CONT.PERC = "0%"
END


Y.TOT.SEGM = Y.CUS.SEG.PLATINUM+Y.CUS.SEG.ORO+Y.CUS.SEG.PLATA+Y.CUS.SEG.BRONZE+Y.CUS.SEG.COBRE

IF Y.CUS.SEG.PLATINUM NE 0 AND Y.TOT.SEGM NE 0 THEN
Y.CUS.SEG.PLATINUM.PER = DROUND(((Y.CUS.SEG.PLATINUM/Y.TOT.SEGM)*100),0):"%"
END ELSE
Y.CUS.SEG.PLATINUM.PER = "0%"
END

IF Y.CUS.SEG.ORO NE 0 AND Y.TOT.SEGM NE 0 THEN
Y.CUS.SEG.ORO.PER = DROUND(((Y.CUS.SEG.ORO/Y.TOT.SEGM)*100),0):"%"
END ELSE
Y.CUS.SEG.ORO.PER = "0%"
END

IF Y.CUS.SEG.PLATA NE 0 AND Y.TOT.SEGM NE 0 THEN
Y.CUS.SEG.PLATA.PER = DROUND(((Y.CUS.SEG.PLATA/Y.TOT.SEGM)*100),0):"%"
END ELSE
Y.CUS.SEG.PLATA.PER = "0%"
END

IF Y.CUS.SEG.BRONZE NE 0 AND Y.TOT.SEGM NE 0 THEN
Y.CUS.SEG.BRONZE.PER = DROUND(((Y.CUS.SEG.BRONZE/Y.TOT.SEGM)*100),0):"%"
END ELSE
Y.CUS.SEG.BRONZE.PER = "0%"
END

IF Y.CUS.SEG.COBRE NE 0 AND Y.TOT.SEGM NE 0 THEN
Y.CUS.SEG.COBRE.PER = DROUND(((Y.CUS.SEG.COBRE/Y.TOT.SEGM)*100),0):"%"
END ELSE
Y.CUS.SEG.COBRE.PER = "0%"
END


Y.TOT.SEGM.PROS = Y.PRO.SEG.PLATINUM+Y.PRO.SEG.ORO+Y.PRO.SEG.PLATA+Y.PRO.SEG.BRONZE+Y.PRO.SEG.COBRE
IF Y.PRO.SEG.PLATINUM NE 0 AND Y.TOT.SEGM.PROS NE 0 THEN
Y.PRO.SEG.PLATINUM.PER = DROUND(((Y.PRO.SEG.PLATINUM/Y.TOT.SEGM.PROS)*100),0):"%"
END ELSE
Y.PRO.SEG.PLATINUM.PER = "0%"
END

IF Y.PRO.SEG.ORO NE 0 AND Y.TOT.SEGM.PROS NE 0 THEN
Y.PRO.SEG.ORO.PER = DROUND(((Y.PRO.SEG.ORO/Y.TOT.SEGM.PROS)*100),0):"%"
END ELSE
Y.PRO.SEG.ORO.PER = "0%"
END

IF Y.PRO.SEG.PLATA NE 0 AND Y.TOT.SEGM.PROS NE 0 THEN
Y.PRO.SEG.PLATA.PER = DROUND(((Y.PRO.SEG.PLATA/Y.TOT.SEGM.PROS)*100),0):"%"
END ELSE
Y.PRO.SEG.PLATA.PER = "0%"
END

IF Y.PRO.SEG.BRONZE NE 0 AND Y.TOT.SEGM.PROS NE 0 THEN
Y.PRO.SEG.BRONZE.PER = DROUND(((Y.PRO.SEG.BRONZE/Y.TOT.SEGM.PROS)*100),0):"%"
END ELSE
Y.PRO.SEG.BRONZE.PER = "0%"
END

IF Y.PRO.SEG.COBRE NE 0 AND Y.TOT.SEGM.PROS NE 0 THEN
Y.PRO.SEG.COBRE.PER = DROUND(((Y.PRO.SEG.COBRE/Y.TOT.SEGM.PROS)*100),0):"%"
END ELSE
Y.PRO.SEG.COBRE.PER = "0%"
END

IF Y.NO.SEGMENT NE 0 AND Y.TOT.SEGM.PROS NE 0 THEN
R.NO.SEG.PER = DROUND(((Y.NO.SEGMENT/Y.TOT.SEGM.PROS)*100),0):"%"
END ELSE
IF Y.NO.SEGMENT NE 0 AND Y.TOT.SEGM.PROS EQ 0 THEN
R.NO.SEG.PER = "100%"
END ELSE
R.NO.SEG.PER = "0%"
END
END

IF Y.ACCEPT.OFR NE 0 AND Y.TOT.CONT NE 0 THEN
Y.ACCEPT.OFR.PER = DROUND(((Y.ACCEPT.OFR/Y.TOT.CONT)*100),0):"%"
END ELSE
Y.ACCEPT.OFR.PER = "0%"
END

IF Y.REF.OFR NE 0 AND Y.TOT.CONT NE 0 THEN
Y.REF.OFR.PER = DROUND(((Y.REF.OFR/Y.TOT.CONT)*100),0):"%"
END ELSE
Y.REF.OFR.PER = "0%"
END

IF Y.RESCH.CONT NE 0 AND Y.TOT.CONT NE 0 THEN
Y.RESCH.CONT.PER = DROUND(((Y.RESCH.CONT/Y.TOT.CONT)*100),0):"%"
END ELSE
Y.RESCH.CONT.PER = "0%"
END

IF Y.REJ.OFR NE 0 AND Y.TOT.CONT NE 0 THEN
Y.REJ.OFR.PER = DROUND(((Y.REJ.OFR/Y.TOT.CONT)*100),0):"%"
END ELSE
Y.REJ.OFR.PER = "0%"
END

IF Y.NO.ANS NE 0 AND Y.TOT.NOT.CONT NE 0 THEN
Y.NO.ANS.PER = DROUND(((Y.NO.ANS/Y.TOT.NOT.CONT)*100),0):"%"
END ELSE
Y.NO.ANS.PER = "0%"
END

IF Y.BUSY.PH.NO NE 0 AND Y.TOT.NOT.CONT NE 0 THEN
Y.BUSY.PH.NO.PER = DROUND(((Y.BUSY.PH.NO/Y.TOT.NOT.CONT)*100),0):"%"
END ELSE
Y.BUSY.PH.NO.PER = "0%"
END

IF Y.INC.PH.NO NE 0 AND Y.TOT.NOT.CONT NE 0 THEN
Y.INC.PH.NO.PER = DROUND(((Y.INC.PH.NO/Y.TOT.NOT.CONT)*100),0):"%"
END ELSE
Y.INC.PH.NO.PER = "0%"
END

IF Y.DISC.PH.NO NE 0 AND Y.TOT.NOT.CONT NE 0 THEN
Y.DISC.PH.NO.PER = DROUND(((Y.DISC.PH.NO/Y.TOT.NOT.CONT)*100),0):"%"
END ELSE
Y.DISC.PH.NO.PER = "0%"
END

RETURN
*-----------------------------------------------------------------------------
CLEAR.VALUES:
*------------

Y.DESCRIPTION.FIN = ''; Y.START.DATE.FIN = ''; Y.END.DATE.FIN = ''; Y.DESCRIPTION = ''; Y.START.DATE = ''; Y.END.DATE = ''

Y.TOT.CUS = 0; Y.CUS.PERC = 0; Y.CUS.CONT = 0; Y.CUS.CON.PER = 0; Y.CUS.NOT.CONT = 0; Y.CUS.NOT.CON.PER = 0; Y.NO.CLIENTS = 0; Y.NO.CLIENTS.CONT = 0; Y.NO.PROS = 0; Y.NO.PROS.CONT = 0

Y.CLIENTS.PERC = 0; Y.CLIENTS.CONT.PERC = 0; Y.PROS.PERC = 0; Y.PROS.CONT.PERC = 0; Y.CUS.SEG.PLATINUM = 0; Y.CUS.SEG.ORO = 0; Y.CUS.SEG.PLATA = 0

Y.CUS.SEG.BRONZE = 0; Y.CUS.SEG.COBRE = 0; Y.CUS.SEG.PLATINUM.PER = 0; Y.CUS.SEG.ORO.PER = 0; Y.CUS.SEG.PLATA.PER = 0; Y.CUS.SEG.BRONZE.PER = 0; Y.CUS.SEG.COBRE.PER = 0

Y.PRO.SEG.PLATINUM = 0; Y.PRO.SEG.ORO = 0; Y.PRO.SEG.PLATA = 0; Y.PRO.SEG.BRONZE = 0; Y.PRO.SEG.COBRE = 0

Y.PRO.SEG.PLATINUM.PER = 0; Y.PRO.SEG.ORO.PER = 0; Y.PRO.SEG.PLATA.PER = 0; Y.PRO.SEG.BRONZE.PER = 0; Y.PRO.SEG.COBRE.PER = 0; Y.NO.SEGMENT = 0; R.NO.SEG.PER = 0

Y.TOT.CONT = 0; Y.TOT.NOT.CONT = 0; Y.ACCEPT.OFR = 0; Y.REF.OFR = 0; Y.RESCH.CONT = 0; Y.REJ.OFR = 0; Y.ACCEPT.OFR.PER = 0; Y.REF.OFR.PER = 0; Y.RESCH.CONT.PER = 0; Y.REJ.OFR.PER = 0

Y.NO.ANS = 0; Y.BUSY.PH.NO = 0; Y.INC.PH.NO = 0; Y.DISC.PH.NO = 0; Y.NO.ANS.PER = 0; Y.BUSY.PH.NO.PER = 0; Y.INC.PH.NO.PER = 0; Y.DISC.PH.NO.PER = 0

RETURN
*-----------------------------------------------------------------------------
FORM.ARRAY:
*----------

IF DATA.RECORD EQ '' THEN
*01-10
DATA.RECORD = Y.DESCRIPTION.FIN:"*":Y.START.DATE.FIN:"*":Y.END.DATE.FIN:"*":Y.TOT.CUS:"*":Y.CUS.PERC:"*":Y.CUS.CONT:"*":Y.CUS.CON.PER:"*":Y.CUS.NOT.CONT:"*":Y.CUS.NOT.CON.PER:"*":Y.CUS.CONT:"*"
*11-20
DATA.RECORD := Y.NO.CLIENTS:"*":Y.CLIENTS.PERC:"*":Y.NO.CLIENTS.CONT:"*":Y.CLIENTS.CONT.PERC:"*":Y.NO.PROS:"*":Y.PROS.PERC:"*":Y.NO.PROS.CONT:"*":Y.PROS.CONT.PERC:"*":Y.CUS.SEG.PLATINUM:"*":Y.CUS.SEG.ORO:"*"
*21-30
DATA.RECORD := Y.CUS.SEG.PLATA:"*":Y.CUS.SEG.BRONZE:"*":Y.CUS.SEG.COBRE:"*":Y.CUS.SEG.PLATINUM.PER:"*":Y.CUS.SEG.ORO.PER:"*":Y.CUS.SEG.PLATA.PER:"*":Y.CUS.SEG.BRONZE.PER:"*":Y.CUS.SEG.COBRE.PER:"*":Y.PRO.SEG.PLATINUM:"*":Y.PRO.SEG.ORO:"*"
*31-40
DATA.RECORD := Y.PRO.SEG.PLATA:"*":Y.PRO.SEG.BRONZE:"*":Y.PRO.SEG.COBRE:"*":Y.PRO.SEG.PLATINUM.PER:"*":Y.PRO.SEG.ORO.PER:"*":Y.PRO.SEG.PLATA.PER:"*":Y.PRO.SEG.BRONZE.PER:"*":Y.PRO.SEG.COBRE.PER:"*":Y.NO.SEGMENT:"*":R.NO.SEG.PER:"*"
*41-50
DATA.RECORD := Y.TOT.CONT:"*":Y.TOT.NOT.CONT:"*":Y.ACCEPT.OFR:"*":Y.REF.OFR:"*":Y.RESCH.CONT:"*":Y.REJ.OFR:"*":Y.ACCEPT.OFR.PER:"*":Y.REF.OFR.PER:"*":Y.RESCH.CONT.PER:"*":Y.REJ.OFR.PER:"*"
*51-60
DATA.RECORD := Y.NO.ANS:"*":Y.BUSY.PH.NO:"*":Y.INC.PH.NO:"*":Y.DISC.PH.NO:"*":Y.NO.ANS.PER:"*":Y.BUSY.PH.NO.PER:"*":Y.INC.PH.NO.PER:"*":Y.DISC.PH.NO.PER
END ELSE
*01-10
DATA.RECORD<-1> = Y.DESCRIPTION.FIN:"*":Y.START.DATE.FIN:"*":Y.END.DATE.FIN:"*":Y.TOT.CUS:"*":Y.CUS.PERC:"*":Y.CUS.CONT:"*":Y.CUS.CON.PER:"*":Y.CUS.NOT.CONT:"*":Y.CUS.NOT.CON.PER:"*":Y.CUS.CONT:"*"
*11-20
DATA.RECORD := Y.NO.CLIENTS:"*":Y.CLIENTS.PERC:"*":Y.NO.CLIENTS.CONT:"*":Y.CLIENTS.CONT.PERC:"*":Y.NO.PROS:"*":Y.PROS.PERC:"*":Y.NO.PROS.CONT:"*":Y.PROS.CONT.PERC:"*":Y.CUS.SEG.PLATINUM:"*":Y.CUS.SEG.ORO:"*"
*21-30
DATA.RECORD := Y.CUS.SEG.PLATA:"*":Y.CUS.SEG.BRONZE:"*":Y.CUS.SEG.COBRE:"*":Y.CUS.SEG.PLATINUM.PER:"*":Y.CUS.SEG.ORO.PER:"*":Y.CUS.SEG.PLATA.PER:"*":Y.CUS.SEG.BRONZE.PER:"*":Y.CUS.SEG.COBRE.PER:"*":Y.PRO.SEG.PLATINUM:"*":Y.PRO.SEG.ORO:"*"
*31-40
DATA.RECORD := Y.PRO.SEG.PLATA:"*":Y.PRO.SEG.BRONZE:"*":Y.PRO.SEG.COBRE:"*":Y.PRO.SEG.PLATINUM.PER:"*":Y.PRO.SEG.ORO.PER:"*":Y.PRO.SEG.PLATA.PER:"*":Y.PRO.SEG.BRONZE.PER:"*":Y.PRO.SEG.COBRE.PER:"*":Y.NO.SEGMENT:"*":R.NO.SEG.PER:"*"
*41-50
DATA.RECORD := Y.TOT.CONT:"*":Y.TOT.NOT.CONT:"*":Y.ACCEPT.OFR:"*":Y.REF.OFR:"*":Y.RESCH.CONT:"*":Y.REJ.OFR:"*":Y.ACCEPT.OFR.PER:"*":Y.REF.OFR.PER:"*":Y.RESCH.CONT.PER:"*":Y.REJ.OFR.PER:"*"
*51-60
DATA.RECORD := Y.NO.ANS:"*":Y.BUSY.PH.NO:"*":Y.INC.PH.NO:"*":Y.DISC.PH.NO:"*":Y.NO.ANS.PER:"*":Y.BUSY.PH.NO.PER:"*":Y.INC.PH.NO.PER:"*":Y.DISC.PH.NO.PER
END
RETURN
*-----------------------------------------------------------------------------
END
