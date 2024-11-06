This project asks you to implement an endpoint that exposes different views or mappings on an underlying dataset. Our team is primarily focused on two types of work:
* converting data between an insurance carrier's or broker's representation and ThreeFlow's
* writing an API to expose our (current!) best way of thinking about that data.

In this project, you'll do both things:
* you'll write an endpoint to an OAI spec (you can copy-paste this into [a Swagger editor](https://editor-next.swagger.io/) for a nice view)
* you'll shape the same data in two very different ways for different users.

## The ask

We ask that you take no more than 2 hours on this project. The point is not for it to be 'done', but for it to show how you think about this type of work and provide a springboard for a conversation in our interview.

Below you'll find data mappings for the dental and vision coverages for two insurance carriers. They think about all the data points fairly differently (as they do in the real world!). There is one endpoint defined in the app (if you run the server and hit http://localhost:3000/opportunities/2?carrier_id=2 you should see some data!). We want that app to be able to:
* Represent each known product as either carrier `1` or carrier `2`.
* In each representation, match the spec defined in `doc/api.yml`.

The mappings likely have gaps, so you'll have to make assumptions. Document those in the README you share back with us.

## Assumptions/Questions

< Your notes here! >

Initial thoughts
- let's get familiar with the data currently rendered at the existing api endpoint
- using that data, write some tests to assert that the endpoint returns the mapped data

Starting to write tests
- the mapping logic for expected values is a bit vague, but let's get the tests to expect what we can discern.

Acme mapper
- Not sure how to interpret vision commissions mapping. Making an assumption that it's similar to dental commissions

[tine goes by, process can be seen in commit history]

As I'm wrapping things up...
- checked that my solution matches the API spec -- should have looked at this way sooner, before writing my tests. The enums I was confused about at the onset of this are right there. I had assumed that that was one of the gaps in the challenge I had to make assumptions about

Since I've worked on this for a few hours now and the expectations of this project specifiy it doesn't need to be 'done,' I'll choose to stop development here and submit as-is, talking about this learning moment and the changes I'd make at the follow-up call with y'all!

Here's the github repository for this in case you're interested in my commit history: https://github.com/laurenfazah/carrier-connect-challenge

# Data Mappings

## Acme

### Dental

| Their Field | Our Field         | Mapping Logic                                                                                                                           |
| ----------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| id          | id                |                                                                                                                                         |
| commissions | commissions       | If our number is a percentage, render as decimal with 2 significant digits. <br/>Otherwise leave `nil`                                  |
| xray        | x_ray_coinsurance | If our number is a percentage, render as a whole number percentage (string). Round up to get to whole number.<br/>Otherwise leave `nil` |

### Vision

| Their Field        | Our Field   | Mapping Logic                                                                                                                                                                                 |
| ------------------ | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id                 | id          |                                                                                                                                                                                               |
| broker_commissions | commissions | If number is a percent, round down to appropriate enum.<br/>If number is 'PEPM' or 'Per Employee' or 'Per Employee Per Month' (case insensitive), use `PerEmployee`<br/>Otherwise leave `nil` |
| frame_benefit      | frames      | If a dollar amount, round down to whole number.<br/>Otherwise leave `nil`                                                                                                                     |

## Demo Carrier
### Dental

| Their Field                       | Our Field         | Mapping Logic                                                                                    |
| --------------------------------- | ----------------- | ------------------------------------------------------------------------------------------------ |
| id                                | id                |                                                                                                  |
| commissions>commissions_pct       | commissions       | If our number is a percentage, render as whole number. Round down. <br/>Otherwise leave `nil`    |
| commissions>commissions_structure | commissions       | If number is a percentage, `Percent`.<br/>If number is 'flat', `Flat`.<br/>Otherwise leave `nil` |
| x_ray_coinsurance                 | x_ray_coinsurance | If our number is a percentage, round up to correct enum.<br/>Otherwise leave `nil`               |

### Vision

| Their Field        | Our Field   | Mapping Logic                                                                       |
| ------------------ | ----------- | ----------------------------------------------------------------------------------- |
| id                 | id          |                                                                                     |
| broker_commissions | commissions | If number is a percent, display with 2 significant digits<br/>Otherwise leave `nil` |
| frame_benefit      | frames      | If a dollar amount, round up to matching enum.<br/>Otherwise leave `nil`            |

