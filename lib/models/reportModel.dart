class ReportModel {
  List<Report> report;

  ReportModel({this.report});

  ReportModel.fromJson(Map<String, dynamic> json) {
    if (json['report'] != null) {
      report = new List<Report>();
      json['report'].forEach((v) {
        report.add(new Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['report'] = this.report.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Report {
  String name;
  String date;
  String url;

  Report({this.name, this.date, this.url});

  Report.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['customer_contact_number'];
    url = json['collected_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['customer_contact_number'] = this.date;
    data['collected_amount'] = this.url;
    return data;
  }
}
